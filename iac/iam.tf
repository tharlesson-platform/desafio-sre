resource "oci_identity_compartment" "project" {
  compartment_id = var.root_compartment_ocid
  name           = var.compartment_name
  description    = "Desafio SRE - plataforma distribuida"
  enable_delete  = true
}

resource "oci_identity_group" "operators" {
  compartment_id = var.root_compartment_ocid
  name           = "${var.project_prefix}-operators"
  description    = "Grupo de operadores SRE"
}

resource "oci_identity_dynamic_group" "control" {
  compartment_id = var.root_compartment_ocid
  name           = "${var.project_prefix}-dg-control-${local.name_suffix}"
  description    = "Instancias de controle (Sao Paulo)"
  matching_rule  = "ALL {instance.compartment.id = '${oci_identity_compartment.project.id}', instance.freeformTags.role = 'control'}"
}

resource "oci_identity_dynamic_group" "workload" {
  compartment_id = var.root_compartment_ocid
  name           = "${var.project_prefix}-dg-workload-${local.name_suffix}"
  description    = "Instancias de workload (regiao secundaria)"
  matching_rule  = "ALL {instance.compartment.id = '${oci_identity_compartment.project.id}', instance.freeformTags.role = 'workload'}"
}

resource "oci_identity_policy" "operators" {
  compartment_id = var.root_compartment_ocid
  name           = "${var.project_prefix}-operators-policy-${local.name_suffix}"
  description    = "Permissoes minimas para operadores"
  statements = [
    "allow group ${oci_identity_group.operators.name} to use bastion-family in compartment ${oci_identity_compartment.project.name}",
    "allow group ${oci_identity_group.operators.name} to read log-content in compartment ${oci_identity_compartment.project.name}",
    "allow group ${oci_identity_group.operators.name} to read buckets in compartment ${oci_identity_compartment.project.name}",
    "allow group ${oci_identity_group.operators.name} to read objects in compartment ${oci_identity_compartment.project.name}"
  ]
}

resource "oci_identity_policy" "control_access" {
  compartment_id = var.root_compartment_ocid
  name           = "${var.project_prefix}-control-policy-${local.name_suffix}"
  description    = "Controle pode submeter jobs e ler resultados"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.control.name} to use log-content in compartment ${oci_identity_compartment.project.name}",
    "allow dynamic-group ${oci_identity_dynamic_group.control.name} to manage objects in compartment ${oci_identity_compartment.project.name} where target.bucket.name='${local.jobs_bucket}'",
    "allow dynamic-group ${oci_identity_dynamic_group.control.name} to read objects in compartment ${oci_identity_compartment.project.name} where target.bucket.name='${local.results_bucket}'"
  ]
}

resource "oci_identity_policy" "workload_access" {
  compartment_id = var.root_compartment_ocid
  name           = "${var.project_prefix}-workload-policy-${local.name_suffix}"
  description    = "Workload pode ler jobs e enviar resultados"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.workload.name} to use log-content in compartment ${oci_identity_compartment.project.name}",
    "allow dynamic-group ${oci_identity_dynamic_group.workload.name} to read objects in compartment ${oci_identity_compartment.project.name} where target.bucket.name='${local.jobs_bucket}'",
    "allow dynamic-group ${oci_identity_dynamic_group.workload.name} to manage objects in compartment ${oci_identity_compartment.project.name} where target.bucket.name='${local.results_bucket}'"
  ]
}
