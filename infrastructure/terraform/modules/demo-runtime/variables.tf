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
