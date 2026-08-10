variable "project_name" {
  type    = string
  default = "cloudforge"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.30.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)

  default = [
    "10.30.0.0/24",
    "10.30.1.0/24"
  ]
}

variable "private_app_subnet_cidrs" {
  type = list(string)

  default = [
    "10.30.10.0/24",
    "10.30.11.0/24"
  ]
}

variable "private_data_subnet_cidrs" {
  type = list(string)

  default = [
    "10.30.20.0/24",
    "10.30.21.0/24"
  ]
}

variable "application_port" {
  type    = number
  default = 8080
}

