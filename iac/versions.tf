terraform {
  required_version = ">= 1.5"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "8.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
