variable "project_name" {
  description = "CloudForge proje adı."
  type        = string
}

variable "environment" {
  description = "Deployment ortamı."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "vpc_id" {
  description = "CloudForge VPC ID."
  type        = string
}

variable "public_subnet_ids" {
  description = "ALB ve development ECS için kullanılacak public subnetler."
  type        = list(string)
}

variable "private_data_subnet_ids" {
  description = "RDS için kullanılacak private data subnetler."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ALB Security Group."
  type        = string
}

variable "ecs_security_group_id" {
  description = "ECS Security Group."
  type        = string
}

variable "rds_security_group_id" {
  description = "RDS Security Group."
  type        = string
}

variable "ecr_repository_url" {
  description = "Demo application ECR repository URL."
  type        = string
}

variable "image_tag" {
  description = "ECS tarafından çalıştırılacak Docker image tag."
  type        = string
}

variable "application_port" {
  description = "Spring Boot portu."
  type        = number
  default     = 8080
}

variable "application_cpu" {
  description = "Fargate CPU."
  type        = number
  default     = 512
}

variable "application_memory" {
  description = "Fargate memory MiB."
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Çalışacak ECS task sayısı."
  type        = number
  default     = 1
}

variable "database_name" {
  description = "PostgreSQL database adı."
  type        = string
  default     = "cloudforgedemo"
}

variable "database_username" {
  description = "PostgreSQL master user."
  type        = string
  default     = "cloudforge"
}

variable "database_instance_class" {
  description = "Development RDS instance tipi."
  type        = string
  default     = "db.t4g.micro"
}

variable "deploy_service" {
  description = "ECS task definition ve service oluşturulsun mu?"
  type        = bool
  default     = false
}

variable "deployment_strategy" {
  description = "ECS deployment strategy."
  type        = string
  default     = "ROLLING"

  validation {
    condition = contains(
      [
        "ROLLING",
        "BLUE_GREEN"
      ],
      var.deployment_strategy
    )

    error_message = "deployment_strategy ROLLING veya BLUE_GREEN olmalıdır."
  }
}

variable "deployment_bake_time_minutes" {
  description = "Blue ve green revision'ların birlikte çalışacağı süre."
  type        = number
  default     = 2
}

variable "enable_deployment_alarms" {
  description = "ECS deployment sırasında CloudWatch alarm kontrolünü etkinleştirir."
  type        = bool
  default     = false
}

variable "deployment_5xx_threshold" {
  description = "Deployment rollback için iki dakikalık periyotlarda izin verilen 5xx hata eşiği."
  type        = number
  default     = 5
}
variable "enable_autoscaling" {
  description = "ECS Service Auto Scaling etkinleştirilsin mi?"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum ECS task sayısı."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum ECS task sayısı."
  type        = number
  default     = 4

  validation {
    condition     = var.autoscaling_max_capacity >= 1
    error_message = "autoscaling_max_capacity en az 1 olmalıdır."
  }
}

variable "autoscaling_cpu_target" {
  description = "CPU target tracking yüzdesi."
  type        = number
  default     = 60
}

variable "autoscaling_memory_target" {
  description = "Memory target tracking yüzdesi."
  type        = number
  default     = 70
}
