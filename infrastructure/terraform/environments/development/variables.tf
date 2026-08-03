variable "project_name" {
  description = "CloudForge proje adı."
  type        = string
  default     = "cloudforge"
}

variable "environment" {
  description = "Ortam adı."
  type        = string
  default     = "development"
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "Development VPC CIDR."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR listesi."
  type        = list(string)
  default = [
    "10.20.0.0/24",
    "10.20.1.0/24"
  ]
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDR listesi."
  type        = list(string)
  default = [
    "10.20.10.0/24",
    "10.20.11.0/24"
  ]
}

variable "private_data_subnet_cidrs" {
  description = "Private data subnet CIDR listesi."
  type        = list(string)
  default = [
    "10.20.20.0/24",
    "10.20.21.0/24"
  ]
}

variable "application_port" {
  description = "Demo application portu."
  type        = number
  default     = 8080
}
