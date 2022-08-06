output "name" {
  description = ""
  value       = kubernetes_service.this.metadata[0].name
}

output "namespace" {
  description = "Namespace defines the space within which each name must be unique."
  value       = kubernetes_service.this.metadata[0].namespace
}
