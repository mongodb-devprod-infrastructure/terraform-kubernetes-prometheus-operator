<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)    | >= 1.0  |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement_kubernetes) | 2.8.0   |

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| <a name="provider_kubernetes"></a> [kubernetes](#provider_kubernetes) | 2.8.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                   | Type     |
| ---------------------------------------------------------------------------------------------------------------------- | -------- |
| [kubernetes_manifest.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/manifest) | resource |

## Inputs

| Name                                                               | Description                                                                                                                                    | Type                                                                                                                                                                                                                                                                                                                              | Default     | Required |
| ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | :------: |
| <a name="input_annotations"></a> [annotations](#input_annotations) | Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata | `map(any)`                                                                                                                                                                                                                                                                                                                        | `{}`        |    no    |
| <a name="input_labels"></a> [labels](#input_labels)                | Map of string keys and values that can be used to organize and categorize (scope and select) objects                                           | `map(string)`                                                                                                                                                                                                                                                                                                                     | `{}`        |    no    |
| <a name="input_name"></a> [name](#input_name)                      | Name must be unique within a namespace                                                                                                         | `string`                                                                                                                                                                                                                                                                                                                          | n/a         |   yes    |
| <a name="input_namespace"></a> [namespace](#input_namespace)       | Namespace defines the space within which each name must be unique                                                                              | `string`                                                                                                                                                                                                                                                                                                                          | `"default"` |    no    |
| <a name="input_spec"></a> [spec](#input_spec)                      | Specification of desired alerting rule definitions for Prometheus                                                                              | <pre>object({<br> groups = list(object({<br> interval = optional(string)<br> name = string<br> rules = list(object({<br> alert = optional(string)<br> annotations = optional(map(string))<br> expr = any<br> for = optional(string)<br> labels = optional(map(string))<br> record = optional(string)<br> }))<br> }))<br> })</pre> | n/a         |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
