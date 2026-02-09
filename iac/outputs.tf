data "oci_core_vnic_attachments" "control_vnic_attachments" {
  compartment_id = oci_identity_compartment.project.id
  instance_id    = oci_core_instance.control.id
}

data "oci_core_vnic" "control_vnic" {
  vnic_id = data.oci_core_vnic_attachments.control_vnic_attachments.vnic_attachments[0].vnic_id
}

output "compartment_id" {
  value = oci_identity_compartment.project.id
}

output "bastion_id" {
  value = oci_bastion_bastion.home.id
}

output "control_private_ip" {
  value = data.oci_core_vnic.control_vnic.private_ip_address
}

output "jobs_bucket" {
  value = oci_objectstorage_bucket.jobs.name
}

output "results_bucket" {
  value = oci_objectstorage_bucket.results.name
}

output "object_storage_namespace" {
  value = data.oci_objectstorage_namespace.home.namespace
}
