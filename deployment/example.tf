terraform {
  backend "s3" {
    bucket  = "optibrium-devops"
    key     = "terraform/sandbox_deployment.cerella.ai.tfstate"
    profile = "root"
    region  = "eu-west-2"
  }
}

data "terraform_remote_state" "cerella_infra" {
  backend = "s3"

  config = {
    bucket  = "optibrium-devops"
    key     = "terraform/sandbox.cerella.ai.tfstate"
    profile = "root"
    region  = "eu-west-2"
  }
}

provider "aws" {
  profile = "sandbox"
  region  = "eu-west-1"
}

module "cerella" {

  source                       = "../cerella"
  registry_username            = var.registry_username
  registry_password            = var.registry_password
  region                       = "eu-west-1"
  cluster_name                 = data.terraform_remote_state.cerella_infra.outputs.eks_cluster_name
  domain                       = "sandbox.cerella.ai"
  deploy_cerella               = "true"
  external_secret_iam_role_arn = data.terraform_remote_state.cerella_infra.outputs.external_secret_iam_role_arn
  worker_nodes_iam_role_arn    = data.terraform_remote_state.cerella_infra.outputs.worker_nodes_iam_role_arn
  ingest_irsa_iam_role_name    = data.terraform_remote_state.cerella_infra.outputs.ingest_irsa_iam_role_name
  ingest_user_name             = data.terraform_remote_state.cerella_infra.outputs.ingest_user_name
  ingest_user_password         = data.terraform_remote_state.cerella_infra.outputs.ingest_user_password
  cerella_version = "1.0.51"
}
