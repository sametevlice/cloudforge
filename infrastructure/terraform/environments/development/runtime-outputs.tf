output "demo_ecr_repository_url" {
  value = module.demo_ecr.repository_url
}

output "demo_application_url" {
  value = try(module.demo_runtime[0].application_url, null)
}

output "demo_ecs_cluster_name" {
  value = try(module.demo_runtime[0].ecs_cluster_name, null)
}

output "demo_ecs_service_name" {
  value = try(module.demo_runtime[0].ecs_service_name, null)
}

output "demo_database_endpoint" {
  value = try(module.demo_runtime[0].database_endpoint, null)
}
