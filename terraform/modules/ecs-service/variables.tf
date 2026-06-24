variable "service_name" {}

variable "cluster_id" {}

variable "task_definition_arn" {}

variable "subnets" {}

variable "security_groups" {}

variable "target_group_arn" {}

variable "container_name" {}

variable "container_port" {}

variable "enable_execute_command" {
  type    = bool
  default = false
}