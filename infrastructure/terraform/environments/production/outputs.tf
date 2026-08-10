output "environment" {
  description = "Terraform environment adı."
  value       = var.environment
}

output "vpc_id" {
  description = "Production VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Production public subnet ID değerleri."
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Production private application subnet ID değerleri."
  value       = module.vpc.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Production private database subnet ID değerleri."
  value       = module.vpc.private_data_subnet_ids
}

output "demo_application_url" {
  description = "Production demo application URL."
  value       = try(module.demo_runtime[0].application_url, null)
}

output "demo_ecs_cluster_name" {
  description = "Production ECS cluster adı."
  value       = try(module.demo_runtime[0].ecs_cluster_name, null)
}

output "demo_ecs_service_name" {
  description = "Production ECS service adı."
  value       = try(module.demo_runtime[0].ecs_service_name, null)
}

output "demo_database_endpoint" {
  description = "Production RDS endpoint."
  value       = try(module.demo_runtime[0].database_endpoint, null)
}
