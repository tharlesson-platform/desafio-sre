resource "oci_bastion_bastion" "home" {
  compartment_id            = oci_identity_compartment.project.id
  bastion_type              = "STANDARD"
  target_subnet_id          = oci_core_subnet.home_private.id
  client_cidr_block_allow_list = [var.bastion_client_cidr]
  name                      = "${var.project_prefix}-bastion-${local.name_suffix}"
}
