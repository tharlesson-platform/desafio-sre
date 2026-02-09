data "oci_core_services" "workload" {
  provider = oci.workload
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_vcn" "workload" {
  provider       = oci.workload
  cidr_block     = var.workload_vcn_cidr
  display_name   = local.work_vcn_name
  compartment_id = oci_identity_compartment.project.id
  dns_label      = "workvcn"
}

resource "oci_core_nat_gateway" "workload" {
  provider       = oci.workload
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-work-nat-${local.name_suffix}"
  vcn_id         = oci_core_vcn.workload.id
}

resource "oci_core_service_gateway" "workload" {
  provider       = oci.workload
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-work-sgw-${local.name_suffix}"
  vcn_id         = oci_core_vcn.workload.id
  services {
    service_id = data.oci_core_services.workload.services[0].id
  }
}

resource "oci_core_route_table" "workload_private" {
  provider       = oci.workload
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.workload.id
  display_name   = "${var.project_prefix}-work-rt-${local.name_suffix}"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.workload.id
  }

  route_rules {
    destination       = data.oci_core_services.workload.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.workload.id
  }
}

resource "oci_core_subnet" "workload_private" {
  provider                 = oci.workload
  compartment_id           = oci_identity_compartment.project.id
  vcn_id                   = oci_core_vcn.workload.id
  display_name             = "${var.project_prefix}-work-subnet-${local.name_suffix}"
  cidr_block               = var.workload_subnet_cidr
  route_table_id           = oci_core_route_table.workload_private.id
  prohibit_public_ip_on_vnic = true
  dns_label                = "worksub"
}

resource "oci_core_network_security_group" "workload" {
  provider       = oci.workload
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.workload.id
  display_name   = "${var.project_prefix}-work-nsg-${local.name_suffix}"
}

resource "oci_core_network_security_group_security_rule" "workload_ssh" {
  provider                  = oci.workload
  network_security_group_id = oci_core_network_security_group.workload.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.workload_vcn_cidr
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "workload_egress" {
  provider                  = oci.workload
  network_security_group_id = oci_core_network_security_group.workload.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}
