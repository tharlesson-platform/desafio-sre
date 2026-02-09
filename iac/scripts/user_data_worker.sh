#!/bin/bash
set -euo pipefail

if command -v dnf >/dev/null 2>&1; then
  dnf -y install python3 python3-pip jq stress-ng
else
  yum -y install python3 python3-pip jq stress-ng
fi

python3 -m pip install --upgrade oci-cli

cat >/usr/local/bin/workload_agent.sh <<'EOS'
#!/bin/bash
set -euo pipefail

WORKDIR="/var/lib/workload"
mkdir -p "${WORKDIR}"

JOB_FILE="${WORKDIR}/job.json"
LAST_FILE="${WORKDIR}/last_job_id"

if ! oci os object get \
  --namespace "${namespace}" \
  --bucket-name "${jobs_bucket}" \
  --name "jobs/latest.json" \
  --file "${JOB_FILE}" \
  --region "${home_region}" \
  --auth instance_principal >/dev/null; then
  exit 0
fi

JOB_ID="$(jq -r '.job_id // "unknown"' "${JOB_FILE}")"
DURATION="$(jq -r '.duration // 120' "${JOB_FILE}")"

if [[ -f "${LAST_FILE}" ]] && [[ "$(cat "${LAST_FILE}")" == "${JOB_ID}" ]]; then
  exit 0
fi

echo "${JOB_ID}" > "${LAST_FILE}"

TS="$(date -u +%Y%m%dT%H%M%SZ)"
HOST="$(hostname)"
LOG_FILE="${WORKDIR}/${JOB_ID}-${HOST}-${TS}.log"
RESULT_FILE="${WORKDIR}/${JOB_ID}-${HOST}-${TS}.json"

# https://github.com/ColinIanKing/stress-ng

stress-ng --cpu 0 --timeout "${DURATION}s" --metrics-brief | tee "${LOG_FILE}" || true # https://github.com/ColinIanKing/stress-ng

cat > "${RESULT_FILE}" <<JSON
{"job_id":"${JOB_ID}","host":"${HOST}","timestamp":"${TS}","duration":${DURATION},"cpus":$(nproc)}
JSON

oci os object put \
  --namespace "${namespace}" \
  --bucket-name "${results_bucket}" \
  --name "results/${JOB_ID}/${HOST}-${TS}.log" \
  --file "${LOG_FILE}" \
  --region "${home_region}" \
  --auth instance_principal >/dev/null

oci os object put \
  --namespace "${namespace}" \
  --bucket-name "${results_bucket}" \
  --name "results/${JOB_ID}/${HOST}-${TS}.json" \
  --file "${RESULT_FILE}" \
  --region "${home_region}" \
  --auth instance_principal >/dev/null
EOS

chmod +x /usr/local/bin/workload_agent.sh

cat >/etc/systemd/system/workload.service <<'EOS'
[Unit]
Description=HPC workload agent
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/workload_agent.sh
EOS

cat >/etc/systemd/system/workload.timer <<'EOS'
[Unit]
Description=Run workload agent periodically

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
AccuracySec=30s

[Install]
WantedBy=timers.target
EOS

systemctl daemon-reload
systemctl enable --now workload.timer
