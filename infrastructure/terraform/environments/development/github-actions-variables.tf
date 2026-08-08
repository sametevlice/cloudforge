variable "github_repository" {
  description = "GitHub owner/repository."
  type        = string
  default     = "sametevlice/cloudforge"
}

variable "create_github_oidc_provider" {
  description = "AWS hesabında GitHub OIDC provider oluşturulsun mu?"
  type        = bool
  default     = true
}

variable "github_oidc_subject" {
  description = "GitHub repository immutable OIDC subject claim."
  type        = string
}
