


resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<AUTH
- rolearn: ${data.terraform_remote_state.cerella_infra.outputs.worker_nodes_iam_role_arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSControlTowerExecution"
  username: ControlTowerAccess
  groups:
    - system:masters
AUTH
  }
}

# Addon
# Kube Proxy
resource "aws_eks_addon" "kube_proxy" {
  count             = var.enable_eks_addons ? 1 : 0
  cluster_name      = var.cluster_name
  addon_name        = "kube-proxy"
  addon_version     = var.kube_proxy_addon_version
  resolve_conflicts = "OVERWRITE"
  depends_on        = [kubernetes_config_map.aws_auth_configmap]
}

# Kube Proxy
resource "aws_eks_addon" "vpc_cni" {
  count             = var.enable_eks_addons ? 1 : 0
  cluster_name      = var.cluster_name
  addon_name        = "vpc-cni"
  addon_version     = var.vpc_cni_addon_version
  resolve_conflicts = "OVERWRITE"
  depends_on        = [kubernetes_config_map.aws_auth_configmap]
}

# Coredns
resource "aws_eks_addon" "coredns" {
  count             = var.enable_eks_addons ? 1 : 0
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = var.coredns_addon_version
  resolve_conflicts = "OVERWRITE"
  depends_on        = [kubernetes_config_map.aws_auth_configmap]
}
