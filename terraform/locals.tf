locals {
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "193.33.93.0/24"
      display_name = "EN"
    }]
  }]

  tiller_name           = "tiller"
  kube_system_namespace = "kube-system"
}
