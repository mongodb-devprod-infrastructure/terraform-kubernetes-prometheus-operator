locals { name = "prometheus-operator" }

resource "kubernetes_service" "this" {
  metadata {
    labels = {
      app     = "${local.name}-alertmanager"
      release = local.name
    }
    name      = "${local.name}-alertmanager"
    namespace = var.namespace
  }
  spec {
    port {
      name        = "http-web"
      port        = 9093
      protocol    = "TCP"
      target_port = 9093
    }
    selector = {
      alertmanager             = "${local.name}-alertmanager"
      "app.kubernetes.io/name" = "alertmanager"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_account" "this" {
  automount_service_account_token = true
  metadata {
    labels = {
      app                           = "${local.name}-alertmanager"
      "app.kubernetes.io/component" = "alertmanager"
      "app.kubernetes.io/name"      = "${local.name}-alertmanager"
    }
    name      = "${local.name}-alertmanager"
    namespace = var.namespace
  }
}

resource "kubernetes_manifest" "alertmanager" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "Alertmanager"
    metadata = {
      labels = {
        app = "${local.name}-alertmanager"
      }
      name      = "${local.name}-alertmanager"
      namespace = var.namespace
    }
    spec = {
      alertmanagerConfigNamespaceSelector = {}
      alertmanagerConfigSelector          = {}
      portName                            = kubernetes_service.this.spec[0].port[0].name
      replicas                            = var.replicas
      serviceAccountName                  = kubernetes_service_account.this.metadata[0].name
      version                             = "v0.24.0"
    }
  }
}

resource "kubernetes_manifest" "servicemonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      labels = {
        app     = "${local.name}-alertmanager"
        release = local.name
      }
      name      = "${local.name}-alertmanager"
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
          app = "${local.name}-alertmanager"
        }
      }
    }
  }
}
