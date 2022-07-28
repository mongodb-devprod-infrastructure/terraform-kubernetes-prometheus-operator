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

resource "kubernetes_namespace" "this" {
  count = 3

  metadata {
    name = "prometheus-operator-${count.index}"
  }
}

module "prometheus" {
  for_each = toset(kubernetes_namespace.this[*].metadata[0].name)
  source   = "../../modules/prometheus"

  namespace = each.value
}
