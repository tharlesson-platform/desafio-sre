**ADR 001 - Decisoes de Arquitetura**

**Contexto**
Precisamos de uma plataforma distribuida multi-regiao na OCI com controle em Sao Paulo e execucao de workloads intensivos em outra regiao, mantendo acesso seguro, auditavel e reprodutivel por IaC.

**Decisoes**
1. **Controle em Sao Paulo (sa-saopaulo-1)**
   - O controle fica proximo ao time no Brasil e atende ao requisito obrigatorio de SP.

2. **Workload em Ashburn (us-ashburn-1)**
   - Regiao com 3 ADs, ampla oferta de servicos e precos consistentes entre regioes.

3. **Sem IP publico para instancias**
   - Controle e workers ficam em subnets privadas, reduzindo superficie de ataque.

4. **Acesso via Bastion Service**
   - Entrada segura e revogavel, com allowlist por CIDR do operador.

5. **Fila simples por Object Storage**
   - Jobs sao publicados em `jobs/latest.json` e resultados em `results/`, com versionamento.

6. **Observabilidade com OCI Logging + Object Storage**
   - Logs de SO via Logging Agent, resultados e evidencias no Object Storage.

**Justificativas e Trade-offs**
- **Cross-region traffic**: workers em Ashburn escrevem em bucket de SP, o que adiciona latencia e pode gerar custo de egress. Mantemos por simplicidade e auditoria centralizada.
- **Service Gateway e regional**: acesso ao Object Storage de outra regiao nao passa por Service Gateway; usa NAT e internet.
- **Pool em um AD**: simplifica o setup, mas pode enfrentar falta de capacidade. Pode ser expandido com mais `placement_configurations`.

**Alternativas consideradas**
- **Workload em sa-santiago-1**: melhor latencia para Brasil, mas menos ADs.
- **Single-region (SP)**: custo menor, mas nao atende o requisito de multi-regiao.
- **Fila real (Streaming/Queue)**: mais robusta, porem aumenta complexidade e tempo de entrega.

**Consequencias**
- Atendimento aos requisitos de multi-regiao, seguranca e auditabilidade.
- Custo minimo inevitavel fora da home region.
- Plataforma simples, extensivel e adequada para demonstracao tecnica.
