module "demo_ecr" {
  source = "../../modules/ecr"

  project_name    = var.project_name
  environment     = var.environment
  repository_name = "${var.project_name}-demo-app"
}

module "demo_runtime" {
  count  = var.enable_runtime_foundation ? 1 : 0
  source = "../../modules/demo-runtime"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_data_subnet_ids = module.vpc.private_data_subnet_ids

  alb_security_group_id = module.vpc.alb_security_group_id
  ecs_security_group_id = module.vpc.ecs_security_group_id
  rds_security_group_id = module.vpc.rds_security_group_id

  ecr_repository_url = module.demo_ecr.repository_url
  image_tag          = var.demo_image_tag
  deploy_service     = var.deploy_demo_service

  application_port        = var.application_port
  application_cpu         = var.demo_application_cpu
  application_memory      = var.demo_application_memory
  desired_count           = var.demo_desired_count
  database_name           = var.demo_database_name
  database_username       = var.demo_database_username
  database_instance_class = var.demo_database_instance_class
}

check "service_requires_runtime" {
  assert {
    condition     = !var.deploy_demo_service || var.enable_runtime_foundation
    error_message = "deploy_demo_service=true ise enable_runtime_foundation=true olmalıdır."
  }
}

check "service_requires_image" {
  assert {
    condition     = !var.deploy_demo_service || length(trimspace(var.demo_image_tag)) > 0
    error_message = "Demo service için demo_image_tag boş olamaz."
  }
}
