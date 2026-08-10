output "environment" {
  description = "Terraform environment adı."
  value       = var.environment
}

output "vpc_id" {
  description = "Staging VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Staging public subnet ID değerleri."
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Staging private application subnet ID değerleri."
  value       = module.vpc.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Staging private database subnet ID değerleri."
  value       = module.vpc.private_data_subnet_ids
}

output "demo_application_url" {
  description = "Staging demo application URL."
  value       = try(module.demo_runtime[0].application_url, null)
}

output "demo_ecs_cluster_name" {
  description = "Staging ECS cluster adı."
  value       = try(module.demo_runtime[0].ecs_cluster_name, null)
}

output "demo_ecs_service_name" {
  description = "Staging ECS service adı."
  value       = try(module.demo_runtime[0].ecs_service_name, null)
}

output "demo_database_endpoint" {
  description = "Staging RDS endpoint."
  value       = try(module.demo_runtime[0].database_endpoint, null)
}
