output "selected_availability_zones" {
  description = "Development için seçilen iki Availability Zone."
  value       = local.selected_availability_zones
}

output "vpc_id" {
  description = "Development VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet ID listesi."
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private application subnet ID listesi."
  value       = module.vpc.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Private data subnet ID listesi."
  value       = module.vpc.private_data_subnet_ids
}

output "security_group_ids" {
  description = "ALB, ECS ve RDS Security Group ID değerleri."
  value = {
    alb = module.vpc.alb_security_group_id
    ecs = module.vpc.ecs_security_group_id
    rds = module.vpc.rds_security_group_id
  }
}
