variable "enable_runtime_foundation" {
  type    = bool
  default = false
}

variable "deploy_demo_service" {
  type    = bool
  default = false
}

variable "demo_image_tag" {
  type    = string
  default = ""
}

variable "demo_application_cpu" {
  type    = number
  default = 512
}

variable "demo_application_memory" {
  type    = number
  default = 1024
}

variable "demo_desired_count" {
  type    = number
  default = 1
}

variable "demo_database_name" {
  type    = string
  default = "cloudforgestaging"
}

variable "demo_database_username" {
  type    = string
  default = "cloudforge"
}

variable "demo_database_instance_class" {
  type    = string
  default = "db.t4g.micro"
}
