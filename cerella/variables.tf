# variable "acm-certificate-arn" {
#   # if empty, then we create a new certificate. Otherwise, we use the existing one
#   default = ""
# }

# variable "cidr" {
#   default = "10.0.0.0/16"
#   type    = string
# }

# variable "vpc_id" {
#   default = ""
# }

# variable "private_subnet_ids" {
#   default = []
# }

# variable "public_subnet_ids" {
#   default = []
# }

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

# # This might be overridden
# variable "eks-instance-count" {
#   default = 3
# }

# variable "eks-instance-type" {
#   default = "t2.large"
#   type    = string
# }

# variable "eks-version" {
#   default = "1.22"
#   type    = string
# }

# variable "hosted-zone-id" {
#   type    = string
#   default = "" # will disable the creation of the DNS record
# }

# # Normally this would be IP restricted,
# variable "ingress-cidr" {
#   type = list(string)
# }

variable "ingress_version" {
  default = "0.11.3"
}

# variable "irsa_iam_role_name" {
#   default = "external-secrets-readonly"
#   type    = string
# }

# variable "left-availability-zone" {
#   default = "eu-west-1b"
#   type    = string
# }

# variable "left-subnet-cidr" {
#   default = "10.0.2.0/24"
#   type    = string
# }

variable "prometheus_chart_version" {
  default = "38.0.0"
}

variable "region" {
  type    = string
}

variable "registry_password" {
}

variable "registry_username" {
}

variable "external_secret_iam_role_arn" {
  type = string
}

variable "ingest_irsa_iam_role_name" {
  type = string
}

variable "worker_nodes_iam_role_arn" {
  type = string
}

# variable "right-availability-zone" {
#   default = "eu-west-1a"
#   type    = string
# }

# variable "right-subnet-cidr" {
#   default = "10.0.1.0/24"
#   type    = string
# }

# variable "service-account-name" {
#   default = "external-secrets"
#   type    = string
# }

# variable "service-account-namespace" {
#   default = "kube-system"
#   type    = string
# }

# variable "ingest_service_account_namespace" {
#   default = "blue"
#   type    = string
# }

# variable "ingest_service_account_name" {
#   default = "ingest"
#   type    = string
# }

# variable "external_secret_service_account_namespace" {
#   default = "kube-system"
#   type    = string
# }

# variable "external_secret_service_account_name" {
#   default = "external-secrets"
#   type    = string
# }

# Get addon version value by running aws eks describe-addon-versions
variable "kube_proxy_addon_version" {
  default = "v1.22.11-eksbuild.2"
  type    = string
}

variable "vpc_cni_addon_version" {
  default = "v1.11.3-eksbuild.1"
  type    = string
}

variable "coredns_addon_version" {
  default = "v1.8.7-eksbuild.1"
  type    = string
}

# variable "eks-ami" {
#   default = ""
# }

variable "cerella_version" {
  default = "1.0.41"
}

variable "deploy_cerella" {
  default = false
}

# variable "ingest_node_desired_capacity" {
#   type    = number
#   default = 0
# }

# variable "ingest-instance-type" {
#   type = string
# }

variable "enable_eks_addons" {
  default = true
}

# variable "enable_ingest" {
#   default = true
# }

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

# variable "intellegens_intermediate_licence" {
#   default = ""
# }

# variable "intellegens_licence" {
#   default = ""
# }

# variable "cdd_token" {
#   default = ""
# }

# variable "create_secretsmanager" {
#   default = false
# }
