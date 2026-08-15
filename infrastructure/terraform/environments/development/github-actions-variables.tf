variable "create_github_oidc_provider" {
  description = "AWS hesabında GitHub OIDC provider oluşturulsun mu?"
  type        = bool
  default     = true
}

variable "github_repository" {
  description = "GitHub owner/repository formatındaki CloudForge repository adı."
  type        = string
  default     = "sametevlice/cloudforge"
}
