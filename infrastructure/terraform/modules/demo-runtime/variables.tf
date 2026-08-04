variable "project_name" {
  type        = string
  description = "CloudForge proje adı."
}

variable "environment" {
  type        = string
  description = "Ortam adı."
}

variable "aws_region" {
  type        = string
  description = "AWS Region."
}

variable "vpc_id" {
  type        = string
  description = "CloudForge VPC ID."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Development ECS ve ALB public subnet ID'leri."
}

variable "private_data_subnet_ids" {
  type        = list(string)
  description = "RDS private data subnet ID'leri."
}

variable "alb_security_group_id" {
  type        = string
  description = "ALB Security Group ID."
}

variable "ecs_security_group_id" {
  type        = string
  description = "ECS Security Group ID."
}

variable "rds_security_group_id" {
  type        = string
  description = "RDS Security Group ID."
}

variable "ecr_repository_url" {
  type        = string
  description = "Demo application ECR repository URL."
}

variable "image_tag" {
  type        = string
  description = "Deploy edilecek immutable Docker image tag."
}

variable "deploy_service" {
  type        = bool
  description = "Demo ECS service oluşturulsun mu?"
}

variable "application_port" {
  type        = number
  default     = 8080
  description = "Spring Boot application portu."
}

variable "application_cpu" {
  type        = number
  default     = 512
  description = "Fargate task CPU değeri."
}

variable "application_memory" {
  type        = number
  default     = 1024
  description = "Fargate task memory değeri."
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "Çalışacak ECS task sayısı."
}

variable "database_name" {
  type        = string
  default     = "cloudforgedemo"
  description = "PostgreSQL database adı."
}

variable "database_username" {
  type        = string
  default     = "cloudforge"
  description = "PostgreSQL master kullanıcı adı."
}

variable "database_instance_class" {
  type        = string
  default     = "db.t4g.micro"
  description = "Development RDS instance tipi."
}
