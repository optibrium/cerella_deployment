variable "cluster_autoscaler_version" {
  default = "v1.22.3"
}

variable "cluster_ingress_port" {
  default = "30443"
  type    = string
}

variable "cluster_name" {
  type = string
}

variable "domain" {
  type = string
}

variable "ingress_version" {
  default = "0.11.3"
}

variable "prometheus_chart_version" {
  default = "38.0.0"
}

variable "region" {
  type = string
}

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type = string
}

variable "external_secret_iam_role_arn" {
  type = string
}

variable "ingest_irsa_iam_role_name" {
  type = string
}

variable "cerella_version" {
  default = "1.0.50"
}

variable "deploy_cerella" {
  default = false
}

variable "deploy_cloudwatch" {
  default = false
}

variable "elasticsearch_override_file_name" {
  # if empty, then helm release will not use file to override default values
  type    = string
  default = ""
}

variable "cerella_blue_override_file_name" {
  # if empty, then helm release will not use file to override default values
  type    = string
  default = ""
}

variable "cerella_green_override_file_name" {
  # if empty, then helm release will not use file to override default values
  type    = string
  default = ""
}

variable "ingest_user_name" {
  type = string
}

variable "ingest_user_password" {
  type = string
}
