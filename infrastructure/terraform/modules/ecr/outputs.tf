output "repository_name" {
  description = "ECR repository adı."
  value       = aws_ecr_repository.this.name
}

output "repository_url" {
  description = "Docker push ve pull işlemlerinde kullanılacak ECR URL."
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN."
  value       = aws_ecr_repository.this.arn
}
