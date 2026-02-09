tharlesson@Tharlessons-MacBook-Pro iac % terraform plan 
data.oci_identity_availability_domains.home_ads: Reading...
data.oci_objectstorage_namespace.home: Reading...
data.oci_core_services.home: Reading...
data.oci_core_images.home_ol: Reading...
data.oci_core_images.workload_ol: Reading...
data.oci_core_services.workload: Reading...
data.oci_identity_availability_domains.workload_ads: Reading...
data.oci_objectstorage_namespace.home: Read complete after 0s [id=ObjectStorageNamespaceDataSource-0]
data.oci_core_services.home: Read complete after 0s [id=CoreServicesDataSource-0]
data.oci_identity_availability_domains.home_ads: Read complete after 0s [id=IdentityAvailabilityDomainsDataSource-205543731]
data.oci_core_images.home_ol: Read complete after 0s [id=CoreImagesDataSource-4198178771]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform planned the following actions, but then encountered a problem:

  # oci_bastion_bastion.home will be created
  + resource "oci_bastion_bastion" "home" {
      + bastion_type                  = "STANDARD"
      + client_cidr_block_allow_list  = [
          + "203.0.113.10/32",
        ]
      + compartment_id                = (known after apply)
      + defined_tags                  = (known after apply)
      + dns_proxy_status              = (known after apply)
      + freeform_tags                 = (known after apply)
      + id                            = (known after apply)
      + lifecycle_details             = (known after apply)
      + max_session_ttl_in_seconds    = (known after apply)
      + max_sessions_allowed          = (known after apply)
      + name                          = (known after apply)
      + phone_book_entry              = (known after apply)
      + private_endpoint_ip_address   = (known after apply)
      + state                         = (known after apply)
      + static_jump_host_ip_addresses = (known after apply)
      + system_tags                   = (known after apply)
      + target_subnet_id              = (known after apply)
      + target_vcn_id                 = (known after apply)
      + time_created                  = (known after apply)
      + time_updated                  = (known after apply)
    }

  # oci_core_nat_gateway.home will be created
  + resource "oci_core_nat_gateway" "home" {
      + block_traffic  = (known after apply)
      + compartment_id = (known after apply)
      + defined_tags   = (known after apply)
      + display_name   = (known after apply)
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + nat_ip         = (known after apply)
      + public_ip_id   = (known after apply)
      + route_table_id = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)
    }

  # oci_core_nat_gateway.workload will be created
  + resource "oci_core_nat_gateway" "workload" {
      + block_traffic  = (known after apply)
      + compartment_id = (known after apply)
      + defined_tags   = (known after apply)
      + display_name   = (known after apply)
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + nat_ip         = (known after apply)
      + public_ip_id   = (known after apply)
      + route_table_id = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)
    }

  # oci_core_network_security_group.control will be created
  + resource "oci_core_network_security_group" "control" {
      + compartment_id = (known after apply)
      + defined_tags   = (known after apply)
      + display_name   = (known after apply)
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)
    }

  # oci_core_network_security_group.workload will be created
  + resource "oci_core_network_security_group" "workload" {
      + compartment_id = (known after apply)
      + defined_tags   = (known after apply)
      + display_name   = (known after apply)
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)
    }

  # oci_core_network_security_group_security_rule.control_egress will be created
  + resource "oci_core_network_security_group_security_rule" "control_egress" {
      + description               = (known after apply)
      + destination               = "0.0.0.0/0"
      + destination_type          = "CIDR_BLOCK"
      + direction                 = "EGRESS"
      + id                        = (known after apply)
      + is_valid                  = (known after apply)
      + network_security_group_id = (known after apply)
      + protocol                  = "all"
      + source_type               = (known after apply)
      + stateless                 = (known after apply)
      + time_created              = (known after apply)
    }

  # oci_core_network_security_group_security_rule.control_ssh will be created
  + resource "oci_core_network_security_group_security_rule" "control_ssh" {
      + description               = (known after apply)
      + destination               = (known after apply)
      + destination_type          = (known after apply)
      + direction                 = "INGRESS"
      + id                        = (known after apply)
      + is_valid                  = (known after apply)
      + network_security_group_id = (known after apply)
      + protocol                  = "6"
      + source                    = "10.10.0.0/16"
      + source_type               = "CIDR_BLOCK"
      + stateless                 = (known after apply)
      + time_created              = (known after apply)

      + tcp_options {
          + destination_port_range {
              + max = 22
              + min = 22
            }
        }
    }

  # oci_core_network_security_group_security_rule.workload_egress will be created
  + resource "oci_core_network_security_group_security_rule" "workload_egress" {
      + description               = (known after apply)
      + destination               = "0.0.0.0/0"
      + destination_type          = "CIDR_BLOCK"
      + direction                 = "EGRESS"
      + id                        = (known after apply)
      + is_valid                  = (known after apply)
      + network_security_group_id = (known after apply)
      + protocol                  = "all"
      + source_type               = (known after apply)
      + stateless                 = (known after apply)
      + time_created              = (known after apply)
    }

  # oci_core_network_security_group_security_rule.workload_ssh will be created
  + resource "oci_core_network_security_group_security_rule" "workload_ssh" {
      + description               = (known after apply)
      + destination               = (known after apply)
      + destination_type          = (known after apply)
      + direction                 = "INGRESS"
      + id                        = (known after apply)
      + is_valid                  = (known after apply)
      + network_security_group_id = (known after apply)
      + protocol                  = "6"
      + source                    = "10.20.0.0/16"
      + source_type               = "CIDR_BLOCK"
      + stateless                 = (known after apply)
      + time_created              = (known after apply)

      + tcp_options {
          + destination_port_range {
              + max = 22
              + min = 22
            }
        }
    }

  # oci_core_route_table.home_private will be created
  + resource "oci_core_route_table" "home_private" {
      + compartment_id = (known after apply)
      + defined_tags   = (known after apply)
      + display_name   = (known after apply)
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)

      + route_rules {
          + cidr_block        = (known after apply)
          + description       = (known after apply)
          + destination       = "0.0.0.0/0"
          + destination_type  = "CIDR_BLOCK"
          + network_entity_id = (known after apply)
          + route_type        = (known after apply)
        }
      + route_rules {
          + cidr_block        = (known after apply)
          + description       = (known after apply)
          + destination       = "all-gru-services-in-oracle-services-network"
          + destination_type  = "SERVICE_CIDR_BLOCK"
          + network_entity_id = (known after apply)
          + route_type        = (known after apply)
        }
    }

  # oci_core_service_gateway.home will be created
  + resource "oci_core_service_gateway" "home" {
      + block_traffic  = (known after apply)
      + compartment_id = (known after apply)
      + defined_tags   = (known after apply)
      + display_name   = (known after apply)
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)

      + services {
          + service_id   = "ocid1.service.oc1.sa-saopaulo-1.aaaaaaaacd57uig6rzxm2qfipukbqpje2bhztqszh3aj7zk2jtvf6gvntena"
          + service_name = (known after apply)
        }
    }

  # oci_core_subnet.home_private will be created
  + resource "oci_core_subnet" "home_private" {
      + availability_domain        = (known after apply)
      + cidr_block                 = "10.10.1.0/24"
      + compartment_id             = (known after apply)
      + defined_tags               = (known after apply)
      + dhcp_options_id            = (known after apply)
      + display_name               = (known after apply)
      + dns_label                  = "homesub"
      + freeform_tags              = (known after apply)
      + id                         = (known after apply)
      + ipv6cidr_block             = (known after apply)
      + ipv6cidr_blocks            = (known after apply)
      + ipv6virtual_router_ip      = (known after apply)
      + prohibit_internet_ingress  = (known after apply)
      + prohibit_public_ip_on_vnic = true
      + route_table_id             = (known after apply)
      + security_list_ids          = (known after apply)
      + state                      = (known after apply)
      + subnet_domain_name         = (known after apply)
      + time_created               = (known after apply)
      + vcn_id                     = (known after apply)
      + virtual_router_ip          = (known after apply)
      + virtual_router_mac         = (known after apply)
    }

  # oci_core_vcn.home will be created
  + resource "oci_core_vcn" "home" {
      + byoipv6cidr_blocks               = (known after apply)
      + cidr_block                       = "10.10.0.0/16"
      + cidr_blocks                      = (known after apply)
      + compartment_id                   = (known after apply)
      + default_dhcp_options_id          = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_list_id         = (known after apply)
      + defined_tags                     = (known after apply)
      + display_name                     = (known after apply)
      + dns_label                        = "homevcn"
      + freeform_tags                    = (known after apply)
      + id                               = (known after apply)
      + ipv6cidr_blocks                  = (known after apply)
      + ipv6private_cidr_blocks          = (known after apply)
      + is_ipv6enabled                   = (known after apply)
      + is_oracle_gua_allocation_enabled = (known after apply)
      + state                            = (known after apply)
      + time_created                     = (known after apply)
      + vcn_domain_name                  = (known after apply)
    }

  # oci_core_vcn.workload will be created
  + resource "oci_core_vcn" "workload" {
      + byoipv6cidr_blocks               = (known after apply)
      + cidr_block                       = "10.20.0.0/16"
      + cidr_blocks                      = (known after apply)
      + compartment_id                   = (known after apply)
      + default_dhcp_options_id          = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_list_id         = (known after apply)
      + defined_tags                     = (known after apply)
      + display_name                     = (known after apply)
      + dns_label                        = "workvcn"
      + freeform_tags                    = (known after apply)
      + id                               = (known after apply)
      + ipv6cidr_blocks                  = (known after apply)
      + ipv6private_cidr_blocks          = (known after apply)
      + is_ipv6enabled                   = (known after apply)
      + is_oracle_gua_allocation_enabled = (known after apply)
      + state                            = (known after apply)
      + time_created                     = (known after apply)
      + vcn_domain_name                  = (known after apply)
    }

  # oci_identity_compartment.project will be created
  + resource "oci_identity_compartment" "project" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaakuyo2fvbvogmwg4o6op3dmjhh7n4t3qbrt5iw4kydyjvr7ga2mba"
      + defined_tags   = (known after apply)
      + description    = "Desafio SRE - plataforma distribuida"
      + enable_delete  = true
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + is_accessible  = (known after apply)
      + name           = "sre-distributed-platform"
      + state          = (known after apply)
      + time_created   = (known after apply)
    }

  # oci_identity_dynamic_group.control will be created
  + resource "oci_identity_dynamic_group" "control" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaakuyo2fvbvogmwg4o6op3dmjhh7n4t3qbrt5iw4kydyjvr7ga2mba"
      + defined_tags   = (known after apply)
      + description    = "Instancias de controle (Sao Paulo)"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + matching_rule  = (known after apply)
      + name           = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
    }

  # oci_identity_dynamic_group.workload will be created
  + resource "oci_identity_dynamic_group" "workload" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaakuyo2fvbvogmwg4o6op3dmjhh7n4t3qbrt5iw4kydyjvr7ga2mba"
      + defined_tags   = (known after apply)
      + description    = "Instancias de workload (regiao secundaria)"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + matching_rule  = (known after apply)
      + name           = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
    }

  # oci_identity_group.operators will be created
  + resource "oci_identity_group" "operators" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaakuyo2fvbvogmwg4o6op3dmjhh7n4t3qbrt5iw4kydyjvr7ga2mba"
      + defined_tags   = (known after apply)
      + description    = "Grupo de operadores SRE"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + name           = "sre-dist-operators"
      + state          = (known after apply)
      + time_created   = (known after apply)
    }

  # oci_identity_policy.control_access will be created
  + resource "oci_identity_policy" "control_access" {
      + ETag           = (known after apply)
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaakuyo2fvbvogmwg4o6op3dmjhh7n4t3qbrt5iw4kydyjvr7ga2mba"
      + defined_tags   = (known after apply)
      + description    = "Controle pode submeter jobs e ler resultados"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + lastUpdateETag = (known after apply)
      + name           = (known after apply)
      + policyHash     = (known after apply)
      + state          = (known after apply)
      + statements     = (known after apply)
      + time_created   = (known after apply)
      + version_date   = (known after apply)
    }

  # oci_identity_policy.operators will be created
  + resource "oci_identity_policy" "operators" {
      + ETag           = (known after apply)
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaakuyo2fvbvogmwg4o6op3dmjhh7n4t3qbrt5iw4kydyjvr7ga2mba"
      + defined_tags   = (known after apply)
      + description    = "Permissoes minimas para operadores"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + lastUpdateETag = (known after apply)
      + name           = (known after apply)
      + policyHash     = (known after apply)
      + state          = (known after apply)
      + statements     = [
          + "allow group sre-dist-operators to use bastion-family in compartment sre-distributed-platform",
          + "allow group sre-dist-operators to read log-content in compartment sre-distributed-platform",
          + "allow group sre-dist-operators to read buckets in compartment sre-distributed-platform",
          + "allow group sre-dist-operators to read objects in compartment sre-distributed-platform",
        ]
      + time_created   = (known after apply)
      + version_date   = (known after apply)
    }

  # oci_identity_policy.workload_access will be created
  + resource "oci_identity_policy" "workload_access" {
      + ETag           = (known after apply)
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaakuyo2fvbvogmwg4o6op3dmjhh7n4t3qbrt5iw4kydyjvr7ga2mba"
      + defined_tags   = (known after apply)
      + description    = "Workload pode ler jobs e enviar resultados"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + lastUpdateETag = (known after apply)
      + name           = (known after apply)
      + policyHash     = (known after apply)
      + state          = (known after apply)
      + statements     = (known after apply)
      + time_created   = (known after apply)
      + version_date   = (known after apply)
    }

  # oci_logging_log.control will be created
  + resource "oci_logging_log" "control" {
      + compartment_id     = (known after apply)
      + defined_tags       = (known after apply)
      + display_name       = (known after apply)
      + freeform_tags      = (known after apply)
      + id                 = (known after apply)
      + is_enabled         = true
      + log_group_id       = (known after apply)
      + log_type           = "CUSTOM"
      + retention_duration = 30
      + state              = (known after apply)
      + tenancy_id         = (known after apply)
      + time_created       = (known after apply)
      + time_last_modified = (known after apply)
    }

  # oci_logging_log.workload will be created
  + resource "oci_logging_log" "workload" {
      + compartment_id     = (known after apply)
      + defined_tags       = (known after apply)
      + display_name       = (known after apply)
      + freeform_tags      = (known after apply)
      + id                 = (known after apply)
      + is_enabled         = true
      + log_group_id       = (known after apply)
      + log_type           = "CUSTOM"
      + retention_duration = 30
      + state              = (known after apply)
      + tenancy_id         = (known after apply)
      + time_created       = (known after apply)
      + time_last_modified = (known after apply)
    }

  # oci_logging_log_group.control will be created
  + resource "oci_logging_log_group" "control" {
      + compartment_id     = (known after apply)
      + defined_tags       = (known after apply)
      + description        = "Log group do ambiente de controle (Sao Paulo)."
      + display_name       = (known after apply)
      + freeform_tags      = (known after apply)
      + id                 = (known after apply)
      + state              = (known after apply)
      + time_created       = (known after apply)
      + time_last_modified = (known after apply)
    }

  # oci_logging_log_group.workload will be created
  + resource "oci_logging_log_group" "workload" {
      + compartment_id     = (known after apply)
      + defined_tags       = (known after apply)
      + description        = "Log group do workload (Ashburn)."
      + display_name       = (known after apply)
      + freeform_tags      = (known after apply)
      + id                 = (known after apply)
      + state              = (known after apply)
      + time_created       = (known after apply)
      + time_last_modified = (known after apply)
    }

  # oci_logging_unified_agent_configuration.control will be created
  + resource "oci_logging_unified_agent_configuration" "control" {
      + compartment_id      = (known after apply)
      + configuration_state = (known after apply)
      + defined_tags        = (known after apply)
      + description         = "Configuracao do Logging Agent para instancias de controle."
      + display_name        = (known after apply)
      + freeform_tags       = (known after apply)
      + id                  = (known after apply)
      + is_enabled          = true
      + state               = (known after apply)
      + time_created        = (known after apply)
      + time_last_modified  = (known after apply)

      + group_association {
          + group_list = (known after apply)
        }

      + service_configuration {
          + configuration_type = "LOGGING"

          + destination {
              + log_object_id = (known after apply)
            }

          + sources {
              + channels      = (known after apply)
              + custom_plugin = (known after apply)
              + name          = "varlog"
              + paths         = [
                  + "/var/log/messages",
                  + "/var/log/secure",
                  + "/var/log/cloud-init.log",
                ]
              + source_type   = "LOG_TAIL"

              + parser {
                  + delimiter                  = (known after apply)
                  + expression                 = (known after apply)
                  + field_time_key             = (known after apply)
                  + format                     = (known after apply)
                  + format_firstline           = (known after apply)
                  + grok_failure_key           = (known after apply)
                  + grok_name_key              = (known after apply)
                  + is_estimate_current_event  = (known after apply)
                  + is_keep_time_key           = (known after apply)
                  + is_merge_cri_fields        = (known after apply)
                  + is_null_empty_string       = (known after apply)
                  + is_support_colonless_ident = (known after apply)
                  + is_with_priority           = (known after apply)
                  + keys                       = (known after apply)
                  + message_format             = (known after apply)
                  + message_key                = (known after apply)
                  + multi_line_start_regexp    = (known after apply)
                  + null_value_pattern         = (known after apply)
                  + parse_nested               = (known after apply)
                  + parser_type                = "SYSLOG"
                  + rfc5424time_format         = (known after apply)
                  + separator                  = (known after apply)
                  + syslog_parser_type         = (known after apply)
                  + time_format                = (known after apply)
                  + time_type                  = (known after apply)
                  + timeout_in_milliseconds    = (known after apply)
                  + types                      = (known after apply)
                }
            }
        }
    }

  # oci_logging_unified_agent_configuration.workload will be created
  + resource "oci_logging_unified_agent_configuration" "workload" {
      + compartment_id      = (known after apply)
      + configuration_state = (known after apply)
      + defined_tags        = (known after apply)
      + description         = "Configuracao do Logging Agent para instancias de workload."
      + display_name        = (known after apply)
      + freeform_tags       = (known after apply)
      + id                  = (known after apply)
      + is_enabled          = true
      + state               = (known after apply)
      + time_created        = (known after apply)
      + time_last_modified  = (known after apply)

      + group_association {
          + group_list = (known after apply)
        }

      + service_configuration {
          + configuration_type = "LOGGING"

          + destination {
              + log_object_id = (known after apply)
            }

          + sources {
              + channels      = (known after apply)
              + custom_plugin = (known after apply)
              + name          = "varlog"
              + paths         = [
                  + "/var/log/messages",
                  + "/var/log/secure",
                  + "/var/log/cloud-init.log",
                ]
              + source_type   = "LOG_TAIL"

              + parser {
                  + delimiter                  = (known after apply)
                  + expression                 = (known after apply)
                  + field_time_key             = (known after apply)
                  + format                     = (known after apply)
                  + format_firstline           = (known after apply)
                  + grok_failure_key           = (known after apply)
                  + grok_name_key              = (known after apply)
                  + is_estimate_current_event  = (known after apply)
                  + is_keep_time_key           = (known after apply)
                  + is_merge_cri_fields        = (known after apply)
                  + is_null_empty_string       = (known after apply)
                  + is_support_colonless_ident = (known after apply)
                  + is_with_priority           = (known after apply)
                  + keys                       = (known after apply)
                  + message_format             = (known after apply)
                  + message_key                = (known after apply)
                  + multi_line_start_regexp    = (known after apply)
                  + null_value_pattern         = (known after apply)
                  + parse_nested               = (known after apply)
                  + parser_type                = "SYSLOG"
                  + rfc5424time_format         = (known after apply)
                  + separator                  = (known after apply)
                  + syslog_parser_type         = (known after apply)
                  + time_format                = (known after apply)
                  + time_type                  = (known after apply)
                  + timeout_in_milliseconds    = (known after apply)
                  + types                      = (known after apply)
                }
            }
        }
    }

  # oci_objectstorage_bucket.jobs will be created
  + resource "oci_objectstorage_bucket" "jobs" {
      + access_type                  = "NoPublicAccess"
      + approximate_count            = (known after apply)
      + approximate_size             = (known after apply)
      + auto_tiering                 = (known after apply)
      + bucket_id                    = (known after apply)
      + compartment_id               = (known after apply)
      + created_by                   = (known after apply)
      + defined_tags                 = (known after apply)
      + etag                         = (known after apply)
      + freeform_tags                = (known after apply)
      + id                           = (known after apply)
      + is_read_only                 = (known after apply)
      + kms_key_id                   = (known after apply)
      + name                         = (known after apply)
      + namespace                    = "grvndacdf1gv"
      + object_events_enabled        = (known after apply)
      + object_lifecycle_policy_etag = (known after apply)
      + replication_enabled          = (known after apply)
      + storage_tier                 = "Standard"
      + time_created                 = (known after apply)
      + versioning                   = "Enabled"
    }

  # oci_objectstorage_bucket.results will be created
  + resource "oci_objectstorage_bucket" "results" {
      + access_type                  = "NoPublicAccess"
      + approximate_count            = (known after apply)
      + approximate_size             = (known after apply)
      + auto_tiering                 = (known after apply)
      + bucket_id                    = (known after apply)
      + compartment_id               = (known after apply)
      + created_by                   = (known after apply)
      + defined_tags                 = (known after apply)
      + etag                         = (known after apply)
      + freeform_tags                = (known after apply)
      + id                           = (known after apply)
      + is_read_only                 = (known after apply)
      + kms_key_id                   = (known after apply)
      + name                         = (known after apply)
      + namespace                    = "grvndacdf1gv"
      + object_events_enabled        = (known after apply)
      + object_lifecycle_policy_etag = (known after apply)
      + replication_enabled          = (known after apply)
      + storage_tier                 = "Standard"
      + time_created                 = (known after apply)
      + versioning                   = "Enabled"
    }

  # random_id.suffix will be created
  + resource "random_id" "suffix" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 2
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

Plan: 30 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bastion_id               = (known after apply)
  + compartment_id           = (known after apply)
  + jobs_bucket              = (known after apply)
  + object_storage_namespace = "grvndacdf1gv"
  + results_bucket           = (known after apply)