output "state_bucket_name" {
  description = "Terraform remote state S3 bucket adı."
  value       = aws_s3_bucket.terraform_state.id
}

output "development_backend_configuration" {
  description = "Development backend.hcl dosyası için örnek değerler."
  value = {
    bucket       = aws_s3_bucket.terraform_state.id
    key          = "cloudforge/development/terraform.tfstate"
    region       = var.aws_region
    encrypt      = true
    use_lockfile = true
  }
}
