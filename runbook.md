**Runbook Operacional**

**Pre-requisitos**
- Conta OCI com permissao para criar recursos em duas regioes.
- API key configurada localmente para o Terraform.
- IP publico do colaborador para liberar acesso no Bastion.

**Provisionamento**
1. Copie `iac/terraform.tfvars.example` para `iac/terraform.tfvars` e preencha os OCIDs.
2. Execute `terraform -chdir=iac init`.
3. Execute `terraform -chdir=iac apply`.
4. Anote os outputs `bastion_id` e `control_private_ip`.

**Acesso ao ambiente de controle**
1. Crie uma Bastion session (OCI Console ou `oci bastion session create-managed-ssh`).
2. Conecte no control instance via SSH usando o tunel da Bastion session.
3. Validar conectividade: `hostname` e `oci --version`.

**Submeter um job**
1. No control instance, execute `submit_job.sh 120`.
2. Aguarde 2 a 5 minutos para o ciclo do timer nos workers.
3. Liste resultados: `list_results.sh`.
4. Baixe o resultado: `get_result.sh results/<job_id>/<arquivo>.json`.

**Checagens de Saude**
- Controle: `systemctl status workload.timer` (apenas nos workers).
- Buckets: `oci os object list --bucket-name <results>`.
- Logging: verificar logs no OCI Logging (Log Group de controle e de workload).
- IAM: confirmar que o usuario esta no grupo de operadores criado pelo Terraform.

**Escalar workload**
1. Ajuste `workload_pool_size` em `iac/terraform.tfvars`.
2. Execute `terraform -chdir=iac apply`.

**Resposta a Incidentes (exemplos)**
- Sem resultados no bucket. Verificar se o job foi enviado com `oci os object get --bucket-name <jobs> --name jobs/latest.json`. Verificar IAM das dynamic groups. Verificar NAT e rotas do workload.
- CPU muito alta. Reduzir `workload_pool_size`. Ajustar `duration` do job.
- Acesso indevido. Remover usuario do grupo de operadores. Revogar Bastion session.

**Revogacao de Acesso**
1. Remover usuario do grupo de operadores criado pelo Terraform.
2. Revogar Bastion sessions na console.
3. Rotacionar API keys se necessario.

**Desprovisionamento**
- Execute `terraform -chdir=iac destroy`.
