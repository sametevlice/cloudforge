output "role_name" {
  description = "GitHub Actions IAM role adı."
  value       = aws_iam_role.github_ecr.name
}

output "role_arn" {
  description = "GitHub Actions tarafından assume edilecek IAM role ARN."
  value       = aws_iam_role.github_ecr.arn
}

output "oidc_provider_arn" {
  description = "GitHub OIDC provider ARN."
  value       = local.github_oidc_provider_arn
}
