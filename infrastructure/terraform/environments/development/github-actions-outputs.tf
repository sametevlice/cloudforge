output "github_actions_ecr_role_arn" {
  description = "GitHub Actions'ın ECR push için assume edeceği IAM role ARN."
  value       = module.github_actions_ecr.role_arn
}

output "github_oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  value       = module.github_actions_ecr.oidc_provider_arn
}
