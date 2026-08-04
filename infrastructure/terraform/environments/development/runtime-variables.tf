variable "enable_runtime_foundation" {
  type        = bool
  default     = false
  description = "ALB, ECS cluster ve RDS gibi ücretli runtime kaynaklarını etkinleştirir."
}

variable "deploy_demo_service" {
  type        = bool
  default     = false
  description = "Demo ECS service'i etkinleştirir."
}

variable "demo_image_tag" {
  type        = string
  default     = ""
  description = "Deploy edilecek immutable ECR image tag."
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
  default = "cloudforgedemo"
}

variable "demo_database_username" {
  type    = string
  default = "cloudforge"
}

variable "demo_database_instance_class" {
  type    = string
  default = "db.t4g.micro"
}
