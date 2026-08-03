# Terraform State Bootstrap

Bu root module yalnızca Terraform state bucket'ını oluşturur.

## Kullanım

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -out=bootstrap.tfplan
terraform apply bootstrap.tfplan
terraform output
```

Bucket oluşturulduktan sonra output içindeki bucket adını
`environments/development/backend.hcl` dosyasına yaz.
