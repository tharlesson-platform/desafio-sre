resource "oci_logging_log_group" "control" {
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-lg-control-${local.name_suffix}"
  description    = "Log group do ambiente de controle (Sao Paulo)."
}

resource "oci_logging_log" "control" {
  log_group_id       = oci_logging_log_group.control.id
  display_name       = "${var.project_prefix}-log-control-${local.name_suffix}"
  log_type           = "CUSTOM"
  is_enabled         = true
  retention_duration = 30
}

resource "oci_logging_unified_agent_configuration" "control" {
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-ua-control-${local.name_suffix}"
  description    = "Configuracao do Logging Agent para instancias de controle."
  is_enabled     = true

  service_configuration {
    configuration_type = "LOGGING"

    destination {
      log_object_id = oci_logging_log.control.id
    }

    sources {
      source_type = "LOG_TAIL"
      name        = "varlog"
      paths       = ["/var/log/messages", "/var/log/secure", "/var/log/cloud-init.log"]

      parser {
        parser_type = "SYSLOG"
      }
    }
  }

  group_association {
    group_list = [oci_identity_dynamic_group.control.id]
  }
}

resource "oci_logging_log_group" "workload" {
  provider       = oci.workload
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-lg-workload-${local.name_suffix}"
  description    = "Log group do workload (Ashburn)."
}

resource "oci_logging_log" "workload" {
  provider           = oci.workload
  log_group_id       = oci_logging_log_group.workload.id
  display_name       = "${var.project_prefix}-log-workload-${local.name_suffix}"
  log_type           = "CUSTOM"
  is_enabled         = true
  retention_duration = 30
}

resource "oci_logging_unified_agent_configuration" "workload" {
  provider       = oci.workload
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_prefix}-ua-workload-${local.name_suffix}"
  description    = "Configuracao do Logging Agent para instancias de workload."
  is_enabled     = true

  service_configuration {
    configuration_type = "LOGGING"

    destination {
      log_object_id = oci_logging_log.workload.id
    }

    sources {
      source_type = "LOG_TAIL"
      name        = "varlog"
      paths       = ["/var/log/messages", "/var/log/secure", "/var/log/cloud-init.log"]

      parser {
        parser_type = "SYSLOG"
      }
    }
  }

  group_association {
    group_list = [oci_identity_dynamic_group.workload.id]
  }
}
