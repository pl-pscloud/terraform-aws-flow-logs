variable "pscloud_env" {}
variable "pscloud_company" {}
variable "pscloud_project" {}

variable "pscloud_iam_role_arn" { default = null }

variable "pscloud_traffic_type" { default = "ALL" } //ACCEPT, REJECT
variable "pscloud_vpc_id" { default = null }
variable "pscloud_subnet_id" { default = null }