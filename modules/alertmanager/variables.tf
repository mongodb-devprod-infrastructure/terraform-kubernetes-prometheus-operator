variable "labels" {
  default     = {}
  description = "Map of string keys and values that can be used to organize and categorize (scope and select) objects."
  type        = map(string)
}

variable "namespace" {
  default     = "default"
  description = "Namespace defines the space within which each name must be unique."
  type        = string
}

variable "replicas" {
  default     = 1
  description = "Size is the expected size of the alertmanager cluster."
  type        = number
}
