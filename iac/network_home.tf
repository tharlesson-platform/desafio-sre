data "oci_core_services" "home" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_vcn" "home" {
  cidr_block     = var.home_vcn_cidr
  display_name   = local.home_vcn_name
  compartment_id = oci_identity_compartment.project.id
  dns_label      = "homevcn"
}

resource "oci_core_nat_gateway" "home" {
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-home-nat-${local.name_suffix}"
  vcn_id         = oci_core_vcn.home.id
}

resource "oci_core_service_gateway" "home" {
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-home-sgw-${local.name_suffix}"
  vcn_id         = oci_core_vcn.home.id
  services {
    service_id = data.oci_core_services.home.services[0].id
  }
}

resource "oci_core_route_table" "home_private" {
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.home.id
  display_name   = "${var.project_prefix}-home-rt-${local.name_suffix}"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.home.id
  }

  route_rules {
    destination       = data.oci_core_services.home.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.home.id
  }
}

resource "oci_core_subnet" "home_private" {
  compartment_id            = oci_identity_compartment.project.id
  vcn_id                    = oci_core_vcn.home.id
  display_name              = "${var.project_prefix}-home-subnet-${local.name_suffix}"
  cidr_block                = var.home_subnet_cidr
  route_table_id            = oci_core_route_table.home_private.id
  prohibit_public_ip_on_vnic = true
  dns_label                 = "homesub"
}

resource "oci_core_network_security_group" "control" {
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.home.id
  display_name   = "${var.project_prefix}-control-nsg-${local.name_suffix}"
}

resource "oci_core_network_security_group_security_rule" "control_ssh" {
  network_security_group_id = oci_core_network_security_group.control.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.home_vcn_cidr
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "control_egress" {
  network_security_group_id = oci_core_network_security_group.control.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}
