# 声明一个 Helm 容器编排，指定编排到的容器集群在 eks.tf 中声明了

resource "cloudapp_helm_app" "helm_chart" {
  cluster_id     = tencentcloud_eks_cluster.eks.id
  chart_src      = "../software/chart"
  chart_username = var.cloudapp_repo_username
  chart_password = var.cloudapp_repo_password

  chart_values = {
    CAM_ROLE  = var.cloudapp_cam_role
    SUBNET_ID = var.app_target.subnet.id
    IMAGE_CREDENTIALS = {
      REGISTRY = var.cloudapp_repo_server
      USERNAME = var.cloudapp_repo_username
      PASSWORD = var.cloudapp_repo_password
    }
  }
}
