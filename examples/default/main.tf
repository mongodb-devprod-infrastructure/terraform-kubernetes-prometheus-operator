data "aws_eks_cluster" "this" {
  name = replace(terraform.workspace, "default", "production")
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.id
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  host                   = data.aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.this.token
}

resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "prometheus-operator-${random_string.this.result}"
  }
}

module "prometheus" {
  source = "../../modules/prometheus"

  namespace = kubernetes_namespace.this.metadata[0].name
}

resource "helm_release" "this" {
  chart      = "grafana"
  name       = "grafana"
  namespace  = kubernetes_namespace.this.metadata[0].name
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
    name  = "sidecar.datasources.label"
    value = "grafana_datasource"
  }

  set {
    name  = "sidecar.datasources.labelValue"
    value = "1"
  }
}

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
    namespace = helm_release.this.namespace
  }
}
