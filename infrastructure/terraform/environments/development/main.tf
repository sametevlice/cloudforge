data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  selected_availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    2
  )
}

module "vpc" {
  source = "../../modules/vpc"

  project_name              = var.project_name
  environment               = var.environment
  vpc_cidr                  = var.vpc_cidr
  availability_zones        = local.selected_availability_zones
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_app_subnet_cidrs  = var.private_app_subnet_cidrs
  private_data_subnet_cidrs = var.private_data_subnet_cidrs
  application_port          = var.application_port

  tags = {
    Owner = "Samet"
  }
}
