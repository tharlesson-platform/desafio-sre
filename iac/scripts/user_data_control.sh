#!/bin/bash
set -euo pipefail

if command -v dnf >/dev/null 2>&1; then
  dnf -y install python3 python3-pip jq
else
  yum -y install python3 python3-pip jq
fi

python3 -m pip install --upgrade oci-cli

cat >/usr/local/bin/submit_job.sh <<'EOS'
#!/bin/bash
set -euo pipefail

DURATION="$${1:-120}"
JOB_ID="$$(date +%Y%m%d%H%M%S)"

cat >/tmp/job.json <<JSON
{"job_id":"$${JOB_ID}","duration":$${DURATION}}
JSON

oci os object put \
  --namespace "${namespace}" \
  --bucket-name "${jobs_bucket}" \
  --name "jobs/latest.json" \
  --file /tmp/job.json \
  --region "${home_region}" \
  --auth instance_principal

echo "Job enviado: $${JOB_ID} (duracao $${DURATION}s)"
EOS

chmod +x /usr/local/bin/submit_job.sh

cat >/usr/local/bin/list_results.sh <<'EOS'
#!/bin/bash
set -euo pipefail

oci os object list \
  --namespace "${namespace}" \
  --bucket-name "${results_bucket}" \
  --prefix "results/" \
  --region "${home_region}" \
  --auth instance_principal \
  --query 'data[].name' \
  --raw-output
EOS

chmod +x /usr/local/bin/list_results.sh

cat >/usr/local/bin/get_result.sh <<'EOS'
#!/bin/bash
set -euo pipefail

OBJECT_NAME="$${1:-}"
if [[ -z "$${OBJECT_NAME}" ]]; then
  echo "Uso: get_result.sh <object_name>"
  exit 1
fi

oci os object get \
  --namespace "${namespace}" \
  --bucket-name "${results_bucket}" \
  --name "$${OBJECT_NAME}" \
  --file "/tmp/$${OBJECT_NAME##*/}" \
  --region "${home_region}" \
  --auth instance_principal

echo "Salvo em /tmp/$${OBJECT_NAME##*/}"
EOS

chmod +x /usr/local/bin/get_result.sh
