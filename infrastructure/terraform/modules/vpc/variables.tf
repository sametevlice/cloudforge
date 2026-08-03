variable "project_name" {
  description = "Kaynak isimlerinde kullanılacak proje adı."
  type        = string
}

variable "environment" {
  description = "Ortam adı."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR bloğu."
  type        = string
}

variable "availability_zones" {
  description = "Subnetlerin oluşturulacağı Availability Zone listesi."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "En az iki Availability Zone gereklidir."
  }
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR listesi."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDR listesi."
  type        = list(string)
}

variable "private_data_subnet_cidrs" {
  description = "Isolated data subnet CIDR listesi."
  type        = list(string)
}

variable "application_port" {
  description = "ECS application portu."
  type        = number
  default     = 8080
}

variable "database_port" {
  description = "PostgreSQL portu."
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Bütün kaynaklara uygulanacak ek tag'ler."
  type        = map(string)
  default     = {}
}
