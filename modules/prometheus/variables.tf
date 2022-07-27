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
  description = "Number of replicas of each shard to deploy for a Prometheus deployment."
  type        = number
}
