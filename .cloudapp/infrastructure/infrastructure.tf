
variable "app_name" {
  default = "clb_demo"
}

# 引用要求安装时提供的系统变量
variable "cloudapp_target_region" {}
variable "cloudapp_target_availability_zone" {}
variable "cloudapp_target_vpc_id" {}
variable "cloudapp_target_subnet_id" {}
variable "cloudapp_cam_role" {}
variable "cloudapp_repo_server" {}
variable "cloudapp_repo_username" {}
variable "cloudapp_repo_password" {}

provider "tencentcloud" {
  version = "0.0.1"
}


resource "tencentcloud_kubernetes_cluster" "tke-cluster1" {
  availability_zone       = var.cloudapp_target_availability_zone
  vpc_id                  = var.cloudapp_target_vpc_id
  cluster_cidr            = "172.16.0.0/16"
  cluster_os              = "tlinux3.1x86_64"
  cluster_os_type         = "GENERAL"
  cluster_deploy_type     = "MANAGED_CLUSTER"
  cluster_level           = "L5"
  cluster_max_pod_num     = 64
  cluster_max_service_num = 1024
  container_runtime       = "containerd"

  worker_config {
    count                      = 1
    availability_zone          = var.cloudapp_target_availability_zone
    instance_type              = "SA3.MEDIUM2"
    system_disk_type           = "CLOUD_BSSD"
    system_disk_size           = 60
    img_id                     = "img-eb30mz89"
    public_ip_assigned         = false
    internet_max_bandwidth_out = 0
    subnet_id                  = var.cloudapp_target_subnet_id

    data_disk {
      disk_type = "CLOUD_BSSD"
      disk_size = 20
    }
  }

  extension_addon {
    name  = "CBS"
    param = "{\"kind\":\"App\",\"spec\":{\"chart\":{\"chartName\":\"cbs\",\"chartVersion\":\"1.0.6\"},\"values\":{\"values\":[],\"rawValues\":\"e30=\",\"rawValuesType\":\"json\"}}}"
  }
}

resource "cloudapp_helm_app" "app-demo" {
  cluster_id = tencentcloud_kubernetes_cluster.tke-cluster1.id
  chart_src  = "../software/chart"
  chart_values = {
    CAM_ROLE  = var.cloudapp_cam_role
    SUBNET_ID = var.cloudapp_target_subnet_id
    IMAGE_CREDENTIALS = {
      REGISTRY = var.cloudapp_repo_server
      USERNAME = var.cloudapp_repo_username
      PASSWORD = var.cloudapp_repo_password
    }
  }
}

resource "cloudapp_tke_service" "backend" {
  resource_manager = "helm"
  chart_config = {
    cluster_id   = tencentcloud_kubernetes_cluster.tke-cluster1.id
    chart_id     = cloudapp_helm_app.app-demo.id
    service_name = "api-server-service"
  }
}

resource "cloudapp_api_handler" "APIServer" {
  vpc_id           = var.cloudapp_target_vpc_id
  host             = cloudapp_tke_service.backend.host
  handler_protocol = "http"
  handler_path     = "/api/:api_name"
}

resource "cloudapp_api" "GetClbOverview" {
  handler_id = cloudapp_api_handler.APIServer.id
  api_name   = "GetLoadBalanceOverview"
  api_desc   = "获取负载均衡情况"
}
