locals {
  spec = defaults(var.spec, {
    groups = {
      rules = {
        "for" = "0s"
      }
    }
  })
}

resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PrometheusRule"
    metadata = {
      annotations = var.annotations
      labels      = var.labels
      name        = var.name
      namespace   = var.namespace
    }
    spec = local.spec
  }
}
