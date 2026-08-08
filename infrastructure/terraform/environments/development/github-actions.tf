module "github_actions_ecr" {
  source = "../../modules/github-actions-ecr"

  project_name = var.project_name
  environment  = var.environment

  github_repository = var.github_repository
  github_branch     = "main"

  ecr_repository_arn = module.demo_ecr.repository_arn

  create_oidc_provider = var.create_github_oidc_provider
}
