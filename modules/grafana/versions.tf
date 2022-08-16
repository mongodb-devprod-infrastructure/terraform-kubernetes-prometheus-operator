terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
  required_version = ">= 1.0"
}
