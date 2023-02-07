data "aws_eks_cluster" "eks_cluster" {
  name = data.terraform_remote_state.cerella_infra.outputs.eks_cluster_name
}

data "aws_eks_cluster_auth" "environment_auth" {
  name = data.terraform_remote_state.cerella_infra.outputs.eks_cluster_name
}

data "aws_caller_identity" "current" {}
