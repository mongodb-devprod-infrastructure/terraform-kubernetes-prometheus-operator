<div align="center">
  <a href="https://github.com/mongodb-devprod-infrastructure/terraform-kubernetes-prometheus-operator">
    <img src="https://user-images.githubusercontent.com/2184329/145092072-d669fd86-de77-427e-aa78-7bc14e0bf531.png" width="200">
  </a>
  <h1>
    <code>terraform-kubernetes-prometheus-operator</code>
  </h1>
  <p>Terraform modules for creating Prometheus Operator Custom Resource Definitions</p>
</div>

## Purpose

The purpose of this repository is to provide a means of creating Prometheus Operator custom resources using Terraform.

**What is Prometheus Operator?**

Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components. Notably, Prometheus Operator includes custom resources to deploy and manage Prometheus, Alertmanager, and related components.

**Why not Jsonnet?**

The Prometheus community wrote a [design document](https://github.com/monitoring-mixins/docs/blob/master/design.pdf) to present a technique for packaging and deploying extensible and customizable configurations of dashboards, alert definitions, and exporters. The design, known as "Monitoring Mixins", uses [Jsonnet](https://jsonnet.org/) to package together said resources.

While Jsonnet is an incredibly powerful data templating language, it comes with a steep learning curve. For example, The [`kube-prometheus`](https://github.com/prometheus-operator/kube-prometheus) project uses Jsonnet to create dashboards and alerts used to monitor Kubernetes clusters. Understanding how to customize or create new resources using these libraries is not very straightforward and becomes problematic when using the [`kube-prometheus-stack`](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) Helm chart.

Moreover, Terraform offers numerous [providers](https://registry.terraform.io/) to add resources that it can manage. For example, the [AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) can be used to interact with the many resources supported by AWS.

## Usage

This repository comes with the following Terraform modules:

- [`prometheusrule`](modules/prometheusrule) - Creates a [`PrometheusRule`](https://github.com/prometheus-operator/prometheus-operator/blob/main/jsonnet/prometheus-operator/prometheusrules-crd.json) object which defines a desired set of Prometheus alerting and/or recording rules

Instructions for using each module is described in their respective README files. Each module also contains an `examples` directory that contains valid and tested Terraform configurations.

## Contributing

Please refer to the [CONTRIBUTING](docs/CONTRIBUTING.md) document for more information.

## License

[Apache License 2.0](LICENSE)

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana"></a> [grafana](#module\_grafana) | ./modules/grafana | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ./modules/prometheus | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace defines the space within which each name must be unique. | `string` | `"default"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
