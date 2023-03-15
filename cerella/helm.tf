data "aws_caller_identity" "current" {}
resource "helm_release" "ingress" {
  name       = "ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = var.ingress_version

  set {
    name  = "controller.replicaCount"
    value = "1"
  }

  set {
    name  = "controller.healthStatus"
    value = "true"
  }

  set {
    name  = "controller.kind"
    value = "daemonset"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.httpPort.nodePort"
    value = var.cluster_ingress_port
  }

  set {
    name  = "prometheus.create"
    value = true
  }

  set {
    name  = "controller.enableLatencyMetrics"
    value = true
  }

  set {
    name  = "controller.setAsDefaultIngress"
    value = true
  }

  set {
    name  = "controller.config.entries.proxy-body-size"
    value = "2000m"
  }

  set {
    name  = "controller.config.entries.client-max-body-size"
    value = "2000m"
  }

  set {
    name  = "controller.config.entries.max-body-size"
    value = "2000m"
  }

  set {
    name  = "controller.config.entries.proxy-read-timeout"
    value = "300s"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.prometheus_chart_version

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp2"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "20Gi"
  }

  set {
    name  = "prometheus.prometheusSpec.podMetadata.annotations.cluster-autoscaler\\.kubernetes\\.io/safe-to-evict"
    value = "\"true\""
  }

  set {
    name  = "alertmanager.enabled"
    value = false
  }

  set {
    name  = "grafana.podAnnotations.cluster-autoscaler\\.kubernetes\\.io/safe-to-evict"
    value = "\"true\""
  }

}

resource "helm_release" "cluster_autoscaler" {
  name       = "autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "cloudProvider"
    value = "aws"
  }
  set {
    name  = "awsRegion"
    value = var.region
  }
  set {
    name  = "image.tag"
    value = var.cluster_autoscaler_version
  }

}

resource "kubernetes_namespace" "blue" {
  metadata {
    annotations = {
      name = "blue"
    }

    labels = {
      purpose = "blue"
    }

    name = "blue"
  }
}

resource "kubernetes_default_service_account" "blue" {
  metadata {
    namespace = "blue"
  }
  image_pull_secret {
    name = "blue-regcred"
  }
}

resource "kubernetes_secret" "blue-docker-logins" {
  metadata {
    name      = "blue-regcred"
    namespace = "blue"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          auth = "${base64encode("${var.registry_username}:${var.registry_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_namespace" "green" {
  metadata {
    annotations = {
      name                             = "green"
      "meta.helm.sh/release-name"      = "green"
      "meta.helm.sh/release-namespace" = "default"
    }

    labels = {
      purpose                        = "green"
      "app.kubernetes.io/managed-by" = "Helm"
    }

    name = "green"
  }
}

resource "kubernetes_default_service_account" "green" {
  metadata {
    namespace = "green"
  }
  image_pull_secret {
    name = "green-regcred"
  }
}

resource "kubernetes_secret" "green-docker-logins" {
  metadata {
    name      = "green-regcred"
    namespace = "green"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          auth = "${base64encode("${var.registry_username}:${var.registry_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "kube-system"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.external_secret_iam_role_arn
  }
}

resource "helm_release" "aws_efs_csi_driver" {
  count      = var.efs_iam_role_arn != "" && var.efs_fs_id != "" ? 1 : 0
  name       = "aws-efs-csi-driver"
  version    = "2.3.8"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.efs_iam_role_arn
  }
  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.efs_iam_role_arn
  }
  set {
    name  = "storageClasses[0].name"
    value = "efs"
  }
  set {
    name  = "storageClasses[0].parameters.provisioningMode"
    value = "efs-ap"
  }
  set {
    name  = "storageClasses[0].parameters.fileSystemId"
    value = var.efs_fs_id
  }
  set {
    name  = "storageClasses[0].parameters.directoryPerms"
    value = "700"
    type  = "string"
  }
}


resource "helm_release" "cerella_eck" {
  count      = var.deploy_cerella ? 1 : 0
  name       = "eck"
  repository = "https://helm.cerella.ai"
  chart      = "cerella_eck"
  version    = var.cerella_version
  set {
    name  = "domain"
    value = var.domain
  }
}

resource "helm_release" "cerella_elasticsearch" {
  count      = var.deploy_cerella ? 1 : 0
  name       = "elasticsearch"
  repository = "https://helm.cerella.ai"
  chart      = "cerella_elasticsearch"
  version    = var.cerella_version
  depends_on = [helm_release.cerella_eck]
  values     = var.elasticsearch_override_file_name != "" ? [
    "${file("helm-override-values/${var.elasticsearch_override_file_name}")}"
  ] : []
  set {
    name  = "domain"
    value = var.domain
  }
}

resource "helm_release" "cerella_cloudwatch" {
  count      = var.deploy_cloudwatch ? 1 : 0
  name       = "aws-for-fluent-bit"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  version    = "0.1.23"
  set {
    name  = "cloudwatch.region"
    value = var.region
  }
  set {
    name  = "cloudwatch.logGroupName"
    value = "/aws/eks/cerella/${var.cluster_name}/logs"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.cloudwatch_role_arn
  }
  set {
    name  = "firehose.enabled"
    value = "false"
  }
  set {
    name  = "kinesis.enabled"
    value = "false"
  }
  set {
    name  = "elasticsearch.enabled"
    value = "false"
  }
}

resource "helm_release" "cerella_blue" {
  count      = var.deploy_cerella ? 1 : 0
  name       = "blue"
  repository = "https://helm.cerella.ai"
  chart      = "cerella_blue"
  version    = var.cerella_version
  depends_on = [helm_release.cerella_elasticsearch, helm_release.external_secrets]
  values     = var.cerella_blue_override_file_name != "" ? [
    "${file("helm-override-values/${var.cerella_blue_override_file_name}")}"
  ] : []
  set {
    name  = "domain"
    value = var.domain
  }
  set {
    name  = "aws_region"
    value = var.region
  }

  set {
    name  = "aws_account_id"
    value = data.aws_caller_identity.current.account_id
  }

  set {
    name  = "ingest_iam_role_name"
    value = var.ingest_irsa_iam_role_name
  }
}

resource "helm_release" "cerella_green" {
  count      = var.deploy_cerella ? 1 : 0
  name       = "green"
  repository = "https://helm.cerella.ai"
  chart      = "cerella_green"
  version    = var.cerella_version
  depends_on = [helm_release.cerella_elasticsearch, helm_release.external_secrets]
  values     = var.cerella_green_override_file_name != "" ? [
    "${file("helm-override-values/${var.cerella_green_override_file_name}")}"
  ] : []

  set {
    name  = "domain"
    value = var.domain
  }
  set {
    name  = "aws_region"
    value = var.region
  }
  set {
    name  = "aws_account_id"
    value = data.aws_caller_identity.current.account_id
  }
  set {
    name  = "ingest_iam_role_name"
    value = var.ingest_irsa_iam_role_name
  }
  set {
    name  = "ingest_user_name"
    value = var.ingest_user_name
  }
  set {
    name  = "ingest_user_password"
    value = var.ingest_user_password
  }
}
