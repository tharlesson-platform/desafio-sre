**Explicacao do IaC (Terraform)**

Este documento descreve cada arquivo do IaC e como os recursos se conectam para entregar a plataforma multi-regiao na OCI.

**Visao Geral**
O IaC cria:
- Compartimento dedicado ao projeto.
- Duas VCNs privadas: controle em Sao Paulo e workload em Ashburn.
- Bastion Service para acesso seguro ao ambiente de controle.
- Instancia de controle (SP) com scripts de submissao e consulta de resultados.
- Instance Pool de workers (Ashburn) que executam o workload.
- Object Storage com buckets de jobs e results.
- OCI Logging (Log Groups + Logs) e Unified Agent para coleta de logs do SO.
- IAM com grupos e dynamic groups para acesso minimo necessario.

**Estrutura dos Arquivos**

1. `iac/versions.tf`
- Define a versao minima do Terraform e fixa versoes dos providers (`oracle/oci` e `random`).
- Garante reprodutibilidade do ambiente.

2. `iac/providers.tf`
- Define dois providers OCI:
  - Provider principal para a regiao de controle (`home_region`).
  - Provider `oci.workload` para a regiao secundaria (`workload_region`).
- Ambos usam as credenciais locais (tenancy, user, fingerprint, private key).

3. `iac/variables.tf`
- Centraliza variaveis com descricao em portugues.
- Permite customizar regioes, CIDRs, shapes, tamanhos de pool, paths de chaves e parametros de rede.

4. `iac/locals.tf`
- Gera um sufixo aleatorio (`random_id`) para evitar conflito de nomes.
- Monta nomes padronizados para VCNs, buckets, instancias e pool.

5. `iac/iam.tf`
- Cria o compartimento do projeto.
- Cria grupo de operadores e dynamic groups para instancias de controle e workload (por tag `role`).
- Define politicas IAM:
  - Operadores podem usar Bastion e ler logs/objetos.
  - Control pode escrever jobs e ler resultados.
  - Workload pode ler jobs e escrever resultados.
  - Permissoes para uso de logs (log-content).

6. `iac/network_home.tf` (Sao Paulo)
- Cria VCN e subnet privada do controle.
- Cria NAT Gateway para egress e Service Gateway para acesso ao Object Storage.
- Cria route table privada.
- Cria NSG para a instancia de controle (SSH interno e egress liberado).

7. `iac/network_workload.tf` (Ashburn)
- Replica a topologia de rede na regiao secundaria.
- Cria VCN, subnet privada, NAT Gateway e Service Gateway.
- Cria NSG para os workers (SSH interno e egress liberado).

8. `iac/object_storage.tf`
- Cria buckets `jobs` e `results` no Object Storage (SP).
- Habilita versionamento para auditoria.

9. `iac/bastion.tf`
- Cria o Bastion Service, apontado para a subnet privada do controle.
- Restringe o acesso ao CIDR do notebook do operador.

10. `iac/compute_control.tf`
- Cria a instancia de controle em SP.
- Usa shape flexivel (OCPUs/memoria configuraveis).
- Sem IP publico; acesso apenas via Bastion.
- Habilita o plugin de logs (Custom Logs Monitoring).
- Injeta `user_data` com scripts que:
  - Instalam `oci-cli`.
  - Criam `submit_job.sh`, `list_results.sh` e `get_result.sh`.

11. `iac/compute_workload.tf`
- Cria Instance Configuration e Instance Pool na regiao secundaria.
- Workers ficam em subnet privada sem IP publico.
- Habilita o plugin de logs (Custom Logs Monitoring).
- `user_data` instala `stress-ng` e configura o agente de workload:
  - Faz polling de `jobs/latest.json`.
  - Executa carga de CPU por `duration`.
  - Envia logs e resultados para o bucket de results.

12. `iac/logging.tf`
- Cria Log Groups e Logs (um por regiao) no OCI Logging.
- Cria Unified Agent Config para coletar:
  - `/var/log/messages`
  - `/var/log/secure`
  - `/var/log/cloud-init.log`
- Associa a configuracao aos dynamic groups de controle e workload.

13. `iac/outputs.tf`
- Exibe saidas importantes:
  - `bastion_id` e IP privado do controle.
  - nomes dos buckets e namespace do Object Storage.
  - compartment id para referencia.

14. `iac/scripts/user_data_control.sh`
- Script de bootstrap da instancia de controle.
- Instala dependencias e provisiona comandos de operacao.

15. `iac/scripts/user_data_worker.sh`
- Script de bootstrap dos workers.
- Instala dependencias, cria agent de workload e timer systemd.

**Fluxo Operacional (resumo)**
1. Operador conecta no control instance via Bastion.
2. `submit_job.sh` escreve `jobs/latest.json` no bucket de jobs.
3. Workers fazem polling periodico, executam o workload e enviam logs/resultados para o bucket de results.
4. Operador consulta resultados via `list_results.sh` e `get_result.sh`.

**O que os scripts `user_data` fazem**

**`iac/scripts/user_data_control.sh` (instancia de controle)**
- Instala dependencias (`python3`, `pip`, `jq`) via `dnf` ou `yum`.
- Instala o `oci-cli` para acesso ao Object Storage com Instance Principal.
- Cria o script `submit_job.sh`:
  - Gera `job_id` e JSON com duracao.
  - Envia `jobs/latest.json` para o bucket de jobs.
- Cria o script `list_results.sh` para listar objetos do bucket de results.
- Cria o script `get_result.sh` para baixar um objeto de results.

**`iac/scripts/user_data_worker.sh` (workers)**
- Instala dependencias (`python3`, `pip`, `jq`, `stress-ng`).
- Instala o `oci-cli` para acesso ao Object Storage com Instance Principal.
- Cria o agente `workload_agent.sh` que:
  - Faz download de `jobs/latest.json`.
  - Extrai `job_id` e `duration` (com `jq`).
  - Evita reprocessar o mesmo job.
  - Executa `stress-ng` por `duration` segundos.
  - Gera JSON de resultado com host e timestamp.
  - Envia log e JSON para o bucket de results.
- Cria `systemd` service/timer para rodar o agente a cada 5 minutos.

**Seguranca e Compliance**
- Sem IP publico para instancias.
- Bastion com allowlist de IP.
- IAM com privilegio minimo (grupos e dynamic groups).
- Logs do SO enviados ao OCI Logging.
- Objetos versionados para auditoria.

**Riscos e Mitigacoes**
- Falha do control instance interrompe submissao. Mitigacao: criar pool de controle ou instancias standby com Bastion apontando para NSG/target alternativo.
- Trafego cross-region para Object Storage (Ashburn -> SP) aumenta latencia/custo. Mitigacao: bucket local em Ashburn e replicacao para SP.
- Instance Pool em um unico AD pode falhar por falta de capacidade. Mitigacao: adicionar mais `placement_configurations`.
- Dependencia de NAT para egress (logs e updates). Mitigacao: manter Service Gateway para servicos locais e monitorar falhas de egress.
- Logging Agent desabilitado ou com falha. Mitigacao: validar plugin `Custom Logs Monitoring`, checar status do unified agent e criar alertas de ausencia de logs.
- Quotas de shapes/recursos insuficientes. Mitigacao: usar shapes alternativos e solicitar aumento de quota.
- Versionamento de buckets aumenta custo. Mitigacao: criar lifecycle rules para expirar versoes antigas.
- Fila simples (`jobs/latest.json`) permite apenas um job por vez. Mitigacao: evoluir para fila real (Streaming/Queue) ou objetos por job.

**Primeira Execucao na OCI (usuario ja criado)**
1. No Console OCI, gere uma API key para o usuario (User -> API Keys). Baixe a chave privada e copie o fingerprint.
2. Salve a chave privada em `~/.oci/oci_api_key.pem` e aplique permissao `chmod 600 ~/.oci/oci_api_key.pem`.
3. Garanta que o usuario esteja em um grupo com permissoes para criar recursos e IAM no tenancy. Exemplo amplo: `allow group <grupo> to manage all-resources in tenancy`. Para minimo necessario, o grupo precisa ao menos de `manage identity` e `manage` para compute, network, objectstorage, bastion e logging.
4. Pegue `tenancy_ocid` e `user_ocid` no Console OCI.
5. Copie `iac/terraform.tfvars.example` para `iac/terraform.tfvars` e preencha os valores (OCIDs, fingerprint, paths e CIDR).
6. Execute `terraform -chdir=iac init` e `terraform -chdir=iac apply`.
7. Apos criar, use `bastion_id` e `control_private_ip` nos outputs para abrir a sessao Bastion e acessar o control instance.

**Como apresentar (pontos chave)**
- Separacao clara entre plano de controle (SP) e execucao (Ashburn).
- Acesso seguro e revogavel via Bastion e IAM.
- Workload isolado e sem acesso direto externo.
- Observabilidade com Logging Agent + Object Storage.
- IaC reprodutivel e extensivel (pool escalavel, logs, buckets).
