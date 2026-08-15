variable "project_name" {
  description = "CloudForge proje adı."
  type        = string
}

variable "environment" {
  description = "AWS ortam adı."
  type        = string
}

variable "ecr_repository_arn" {
  description = "GitHub Actions'ın image göndereceği ECR repository ARN."
  type        = string
}

variable "create_oidc_provider" {
  description = "GitHub OIDC provider Terraform tarafından oluşturulsun mu?"
  type        = bool
  default     = true
}

variable "github_repository" {
  description = "GitHub owner/repository formatındaki repository adı."
  type        = string
}

variable "github_branch" {
  description = "AWS OIDC erişimine izin verilen GitHub branch."
  type        = string
  default     = "main"
}
