# 云应用系统变量，主要是镜像仓库相关变量
variable "cloudapp_repo_server" {}
variable "cloudapp_repo_username" {}
variable "cloudapp_repo_password" {}
variable "cloudapp_cam_role" {}

variable "app_name" {
  default = "clb_demo"
}

# 用户选择的安装目标位置，VPC 和子网，在 package.yaml 中定义了输入组件
variable "app_target" {
  type = object({
    region    = string
    region_id = string
    vpc = object({
      id         = string
      cidr_block = string
    })
    subnet = object({
      id   = string
      zone = string
    })
  })
}
