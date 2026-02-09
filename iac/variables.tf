variable "tenancy_ocid" {
  description = "OCID da tenancy da OCI."
  type        = string
}

variable "user_ocid" {
  description = "OCID do usuario OCI."
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint da chave de API."
  type        = string
}

variable "private_key_path" {
  description = "Caminho da chave privada da API OCI."
  type        = string
}

variable "root_compartment_ocid" {
  description = "OCID do compartimento raiz (tenancy)."
  type        = string
}

variable "compartment_name" {
  description = "Nome do compartimento do projeto."
  type        = string
  default     = "sre-distributed-platform"
}

variable "project_prefix" {
  description = "Prefixo para nomes de recursos."
  type        = string
  default     = "sre-dist"
}

variable "home_region" {
  description = "Regiao de controle (Sao Paulo)."
  type        = string
  default     = "sa-saopaulo-1"
}

variable "workload_region" {
  description = "Regiao de workload (recomendado: Ashburn por custo/AD/servicos)."
  type        = string
  default     = "us-ashburn-1"
}

variable "home_vcn_cidr" {
  description = "CIDR da VCN de controle."
  type        = string
  default     = "10.10.0.0/16"
}

variable "workload_vcn_cidr" {
  description = "CIDR da VCN de workload."
  type        = string
  default     = "10.20.0.0/16"
}

variable "home_subnet_cidr" {
  description = "CIDR da subnet de controle."
  type        = string
  default     = "10.10.1.0/24"
}

variable "workload_subnet_cidr" {
  description = "CIDR da subnet de workload."
  type        = string
  default     = "10.20.1.0/24"
}

variable "bastion_client_cidr" {
  description = "CIDR publico permitido para abrir sessions do Bastion (IP publico do notebook)."
  type        = string
}

variable "ssh_public_key_path" {
  description = "Caminho da chave SSH publica para a instancia de controle."
  type        = string
}

variable "control_shape" {
  description = "Shape da instancia de controle."
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "control_ocpus" {
  description = "OCPUs da instancia de controle."
  type        = number
  default     = 1
}

variable "control_memory_gbs" {
  description = "Memoria (GB) da instancia de controle."
  type        = number
  default     = 8
}

variable "workload_shape" {
  description = "Shape das instancias de workload."
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "workload_ocpus" {
  description = "OCPUs de cada instancia de workload."
  type        = number
  default     = 2
}

variable "workload_memory_gbs" {
  description = "Memoria (GB) de cada instancia de workload."
  type        = number
  default     = 16
}

variable "workload_pool_size" {
  description = "Tamanho inicial do instance pool de workload."
  type        = number
  default     = 2
}

variable "os_version" {
  description = "Filtro de versao do Oracle Linux."
  type        = string
  default     = "8"
}
