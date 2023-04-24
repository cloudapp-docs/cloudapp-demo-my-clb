# 声明应用包所暴露的应用接口，以及其对应的接口网关和接口后端
resource "cloudapp_tke_service" "api_service" {
  resource_manager = "helm"
  chart_config = {
    cluster_id   = tencentcloud_eks_cluster.eks.id
    chart_id     = cloudapp_helm_app.helm_chart.id
    service_name = "api-server-service"
  }
}

resource "cloudapp_api_handler" "api_gateway" {
  vpc_id           = var.app_target.vpc.id
  host             = cloudapp_tke_service.api_service.host
  handler_protocol = "http"
  handler_path     = "/api/:api_name"
}

resource "cloudapp_api" "GetClbOverview" {
  handler_id = cloudapp_api_handler.api_gateway.id
  api_name   = "GetLoadBalanceOverview"
  api_desc   = "获取负载均衡情况"
}
