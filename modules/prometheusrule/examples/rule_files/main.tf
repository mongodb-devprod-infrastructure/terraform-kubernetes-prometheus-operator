provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  host                   = data.aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster" "this" {
  name = "ProductionCluster"
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

module "prometheusrule" {
  source = "../.."

  // https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/alerting.md#rule-selection
  labels = {
    app     = "kube-prometheus-stack"
    release = "kube-prometheus-stack"
  }

  name      = "alertingrules"
  namespace = "default"
  spec      = yamldecode(file("${path.module}/example.rules.yml"))
}
