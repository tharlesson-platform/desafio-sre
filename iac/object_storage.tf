data "oci_objectstorage_namespace" "home" {}

resource "oci_objectstorage_bucket" "jobs" {
  compartment_id = oci_identity_compartment.project.id
  name           = local.jobs_bucket
  namespace      = data.oci_objectstorage_namespace.home.namespace
  storage_tier   = "Standard"
  versioning     = "Enabled"
}

resource "oci_objectstorage_bucket" "results" {
  compartment_id = oci_identity_compartment.project.id
  name           = local.results_bucket
  namespace      = data.oci_objectstorage_namespace.home.namespace
  storage_tier   = "Standard"
  versioning     = "Enabled"
}
