data "oci_identity_availability_domains" "workload_ads" {
  provider       = oci.workload
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "workload_ol" {
  provider                 = oci.workload
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = var.os_version
  shape                    = var.workload_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance_configuration" "workload" {
  provider       = oci.workload
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-ic-${local.name_suffix}"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = oci_identity_compartment.project.id
      shape          = var.workload_shape

      shape_config {
        ocpus         = var.workload_ocpus
        memory_in_gbs = var.workload_memory_gbs
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
        subnet_id        = oci_core_subnet.workload_private.id
        assign_public_ip = false
        nsg_ids          = [oci_core_network_security_group.workload.id]
      }

      metadata = {
        user_data = base64encode(templatefile("${path.module}/scripts/user_data_worker.sh", {
          namespace      = data.oci_objectstorage_namespace.home.namespace
          jobs_bucket    = local.jobs_bucket
          results_bucket = local.results_bucket
          home_region    = var.home_region
        }))
      }

      source_details {
        source_type = "image"
        image_id    = data.oci_core_images.workload_ol.images[0].id
      }

      freeform_tags = {
        role = "workload"
      }
    }
  }
}

resource "oci_core_instance_pool" "workload" {
  provider                  = oci.workload
  compartment_id            = oci_identity_compartment.project.id
  instance_configuration_id = oci_core_instance_configuration.workload.id
  size                      = var.workload_pool_size
  display_name              = local.pool_name

  placement_configurations {
    availability_domain = data.oci_identity_availability_domains.workload_ads.availability_domains[0].name
    primary_subnet_id   = oci_core_subnet.workload_private.id
  }
}
