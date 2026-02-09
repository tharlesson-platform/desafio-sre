data "oci_identity_availability_domains" "home_ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "home_ol" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = var.os_version
  shape                    = var.control_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "control" {
  availability_domain = data.oci_identity_availability_domains.home_ads.availability_domains[0].name
  compartment_id      = oci_identity_compartment.project.id
  display_name        = local.control_name
  shape               = var.control_shape

  shape_config {
    ocpus         = var.control_ocpus
    memory_in_gbs = var.control_memory_gbs
  }

  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = false

    plugins_config {
      name          = "Custom Logs Monitoring"
      desired_state = "ENABLED"
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.home_private.id
    assign_public_ip = false
    nsg_ids          = [oci_core_network_security_group.control.id]
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(templatefile("${path.module}/scripts/user_data_control.sh", {
      namespace      = data.oci_objectstorage_namespace.home.namespace
      jobs_bucket    = local.jobs_bucket
      results_bucket = local.results_bucket
      home_region    = var.home_region
    }))
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.home_ol.images[0].id
  }

  freeform_tags = {
    role = "control"
  }
}
