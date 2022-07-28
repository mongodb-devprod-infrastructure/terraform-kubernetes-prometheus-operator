output "namespaces" {
  value = [for namespace in kubernetes_namespace.this : namespace.metadata[0].name]
}
