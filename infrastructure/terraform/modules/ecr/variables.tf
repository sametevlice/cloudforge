variable "project_name" {
  description = "Kaynakların ait olduğu proje adı."
  type        = string
}

variable "environment" {
  description = "Kaynağın ait olduğu ortam."
  type        = string
}

variable "repository_name" {
  description = "Amazon ECR repository adı."
  type        = string
}

variable "keep_image_count" {
  description = "ECR repository içerisinde tutulacak maksimum image sayısı."
  type        = number
  default     = 20
}
