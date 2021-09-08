variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "repo_name" {
  type = string
  default = "prm-deductions-mesh-forwarder"
}

variable "component_name" {
  type = string
  default = "mesh-forwarder"
}

variable "task_image_tag" {}
variable "task_cpu" {}
variable "task_memory" {}

variable "environment" {}

variable "service_desired_count" {}

variable "poll_frequency" {}

variable "log_level" {
  type = string
  default = "debug"
}

