variable "project_name" {
  description = "CloudForge proje adı."
  type        = string
}

variable "environment" {
  description = "AWS ortam adı."
  type        = string
}

variable "github_repository" {
  description = "owner/repository formatında GitHub repository."
  type        = string
}

variable "github_branch" {
  description = "AWS erişmesine izin verilen GitHub branch."
  type        = string
  default     = "main"
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

variable "github_subject" {
  description = "GitHub Actions OIDC token içerisindeki exact subject claim."
  type        = string
}
