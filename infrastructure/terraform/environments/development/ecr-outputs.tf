output "demo_ecr_repository_name" {
  description = "CloudForge demo application ECR repository adı."
  value       = module.demo_ecr.repository_name
}

output "demo_ecr_repository_url" {
  description = "CloudForge demo application ECR repository URL."
  value       = module.demo_ecr.repository_url
}
