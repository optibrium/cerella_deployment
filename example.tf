module "cerella" {
  source = "./cerella"
  cluster_name                 = ""
  domain                       = ""
  external_secret_iam_role_arn = ""
  ingest_irsa_iam_role_name    = ""
  ingest_user_name             = ""
  ingest_user_password         = ""
  region                       = ""
  registry_password            = ""
  registry_username            = ""
  worker_nodes_iam_role_arn    = ""
}
