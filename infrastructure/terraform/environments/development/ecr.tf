module "demo_ecr" {
  source = "../../modules/ecr"

  project_name     = var.project_name
  environment      = var.environment
  repository_name  = "cloudforge-demo-app"
  keep_image_count = 20
}
