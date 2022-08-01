locals { name = "prometheus-operator" }

module "alertmanager" {
  source = "../alertmanager"

  namespace = var.namespace
}

resource "kubernetes_service" "this" {
  metadata {
    labels = {
      app     = "${local.name}-prometheus"
      release = local.name
    }
    name      = "${local.name}-prometheus"
    namespace = var.namespace
  }
  spec {
    port {
      name        = "http-web"
      port        = 9090
      protocol    = "TCP"
      target_port = 9090
    }
    selector = {
      "app.kubernetes.io/name" = "prometheus"
      prometheus               = "${local.name}-prometheus"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_account" "this" {
  automount_service_account_token = true
  metadata {
    labels = {
      app                           = "${local.name}-prometheus"
      "app.kubernetes.io/component" = "prometheus"
      "app.kubernetes.io/name"      = "${local.name}-prometheus"
    }
    name      = "${local.name}-prometheus"
    namespace = var.namespace
  }
}

resource "kubernetes_role" "this" {
  metadata {
    name      = "${local.name}-prometheus"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/metrics", "services", "endpoints", "pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "${local.name}-prometheus"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}

resource "kubernetes_secret" "this" {
  metadata {
    name      = "${local.name}-prometheus-scrape-confg"
    namespace = var.namespace
  }
  data = {
    "additional-scrape-configs.yaml" = <<-EOT
- job_name: "prometheus"
  static_configs:
    - targets: ["localhost:9090"]
EOT
  }
  type = "Opaque"
}

resource "kubernetes_manifest" "prometheus" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "Prometheus"
    metadata = {
      labels = {
        app     = "${local.name}-prometheus"
        release = local.name
      }
      name      = "${local.name}-prometheus"
      namespace = var.namespace
    }
    spec = {
      additionalScrapeConfigs = {
        key  = "additional-scrape-configs.yaml"
        name = kubernetes_secret.this.metadata[0].name
      }
      alerting = {
        alertmanagers = [{
          name       = module.alertmanager.name
          namespace  = module.alertmanager.namespace
          pathPrefix = "/"
          port       = module.alertmanager.port
        }]
      }
      enableAdminAPI = false
      replicas       = var.replicas
      resources = {
        requests = {
          memory = "400Mi"
        }
      }
      serviceAccountName = kubernetes_service_account.this.metadata[0].name
      serviceMonitorSelector = {
        matchLabels = {
          release = local.name
        }
      }
      version = "v2.36.1"
    }
  }
}

resource "kubernetes_manifest" "servicemonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      labels = {
        app     = "${local.name}-prometheus"
        release = local.name
      }
      name      = "${local.name}-prometheus"
      namespace = var.namespace
    }
    spec = {
      endpoints = [{
        path = "/metrics"
        port = kubernetes_service.this.spec[0].port[0].name
      }]
      namespaceSelector = {
        matchNames = [var.namespace]
      }
      selector = {
        matchLabels = {
          app     = "${local.name}-prometheus"
          release = local.name
        }
      }
    }
  }
}
