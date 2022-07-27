output "name" {
  value = kubernetes_manifest.alertmanager.object.metadata.name
}

output "namespace" {
  value = kubernetes_manifest.alertmanager.object.metadata.namespace
}

output "port" {
  value = kubernetes_service.this.spec[0].port[0].name
}
