resource "helm_release" "this" {
  chart      = "grafana"
  name       = "grafana"
  namespace  = var.namespace
  repository = "https://grafana.github.io/helm-charts"

  set {
    name  = "sidecar.dashboards.enabled"
    value = true
  }

  set {
    name  = "sidecar.datasources.enabled"
    value = true
  }

  set {
    name  = "sidecar.dashboards.label"
    value = "grafana_dashboard"
  }

  set {
    name  = "sidecar.dashboards.labelValue"
    value = "1"
  }

  set {
    name  = "sidecar.datasources.label"
    value = "grafana_datasource"
  }

  set {
    name  = "sidecar.datasources.labelValue"
    value = "1"
  }
}
