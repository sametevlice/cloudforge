# Development Environment

Bu ortam ilk aşamada şu kaynakları oluşturur:

- VPC
- Internet Gateway
- İki public subnet
- İki private application subnet
- İki isolated data subnet
- Route table ve association kaynakları
- ALB, ECS ve RDS Security Group'ları

Şu kaynaklar henüz oluşturulmaz:

- NAT Gateway
- Application Load Balancer
- ECS cluster/service
- RDS instance
- Public IPv4 adresi

## Hazırlık

```bash
cp terraform.tfvars.example terraform.tfvars
cp backend.hcl.example backend.hcl
```

`backend.hcl` içindeki bucket değerini bootstrap output ile değiştir.
