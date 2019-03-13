resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "${local.tiller_name}"
    namespace = "${local.kube_system_namespace}"
  }

  automount_service_account_token = true

  depends_on = ["google_container_cluster.primary"]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "${local.tiller_name}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${local.tiller_name}"
    namespace = "${local.kube_system_namespace}"
    api_group = ""
  }

  depends_on = ["kubernetes_service_account.tiller"]
}
