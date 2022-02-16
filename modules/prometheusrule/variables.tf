variable "annotations" {
  default     = {}
  description = "Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata"
  type        = map(any)
}

variable "labels" {
  default     = {}
  description = "Map of string keys and values that can be used to organize and categorize (scope and select) objects"
  type        = map(string)
}

variable "name" {
  description = "Name must be unique within a namespace"
  type        = string
}

variable "namespace" {
  default     = "default"
  description = "Namespace defines the space within which each name must be unique"
  type        = string
}

variable "spec" {
  description = "Specification of desired alerting rule definitions for Prometheus"

  type = object({
    groups = list(object({
      interval = optional(string)
      name     = string
      rules = list(object({
        alert       = optional(string)
        annotations = optional(map(string))
        expr        = any
        for         = optional(string)
        labels      = optional(map(string))
        record      = optional(string)
      }))
    }))
  })
}
