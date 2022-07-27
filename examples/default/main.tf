data "aws_eks_cluster" "this" {
  name = replace(terraform.workspace, "default", "production")
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.id
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  host                   = data.aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.this.token
}

resource "random_string" "this" {
  length  = 8
  numeric = false
  special = false
  upper   = false
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "prometheus-operator-${random_string.this.result}"
  }
}

module "prometheus" {
  source = "../../modules/prometheus"

  namespace = kubernetes_namespace.this.metadata[0].name
}
