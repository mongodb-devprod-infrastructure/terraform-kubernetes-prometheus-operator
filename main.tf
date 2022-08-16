module "prometheus" {
  source = "./modules/prometheus"

  namespace = var.namespace
}

module "grafana" {
  source = "./modules/grafana"

  namespace = module.prometheus.namespace
}

// https://github.com/grafana/helm-charts/tree/main/charts/grafana#sidecar-for-datasources
resource "kubernetes_config_map" "this" {
  data = {
    "datasource.yaml" = yamlencode({
      apiVersion = 1
      datasources = [{
        access    = "proxy"
        isDefault = true
        jsonData = {
          timeInterval = "30s"
        }
        name = "Prometheus"
        type = "prometheus"
        url  = "http://${module.prometheus.name}.${module.prometheus.namespace}:9090/"
      }]
    })
  }
  metadata {
    labels = {
      grafana_datasource = "1"
    }
    name      = "prometheus"
    namespace = module.prometheus.namespace
  }
}
