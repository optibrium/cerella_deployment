data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "environment_auth" {
  name = var.cluster_name
}

data "aws_caller_identity" "current" {}

