resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  name_suffix     = random_id.suffix.hex
  compartment_tag = "${var.project_prefix}-${local.name_suffix}"
  home_vcn_name   = "${var.project_prefix}-home-${local.name_suffix}"
  work_vcn_name   = "${var.project_prefix}-work-${local.name_suffix}"
  jobs_bucket     = "${var.project_prefix}-jobs-${local.name_suffix}"
  results_bucket  = "${var.project_prefix}-results-${local.name_suffix}"
  control_name    = "${var.project_prefix}-control-${local.name_suffix}"
  pool_name       = "${var.project_prefix}-pool-${local.name_suffix}"
}
