# Network Validation Checklist

## Terraform kontrolleri

```bash
terraform fmt -check
terraform validate
tflint
checkov -d .
```

## VPC

- [ ] VPC CIDR `10.20.0.0/16`
- [ ] DNS support açık
- [ ] DNS hostnames açık
- [ ] Internet Gateway bağlı
- [ ] Public subnetlerde IGW rotası var
- [ ] Private data subnetlerde internet rotası yok
- [ ] Subnet CIDR'leri çakışmıyor

## ALB

- [ ] İki Availability Zone subneti seçilmiş
- [ ] Internet-facing
- [ ] Port 80 HTTPS'e redirect
- [ ] Port 443 sertifika kullanıyor
- [ ] Health check path doğru

## ECS

- [ ] Production-like profilde private app subnetleri kullanılıyor
- [ ] Production-like profilde public IP kapalı
- [ ] Task SG inbound yalnızca ALB SG
- [ ] ECR image pull başarılı
- [ ] CloudWatch log gönderimi başarılı
- [ ] Secrets Manager erişimi başarılı

## RDS

- [ ] `publicly_accessible = false`
- [ ] DB subnet group iki AZ içeriyor
- [ ] RDS SG yalnızca ECS SG'den 5432 kabul ediyor

## Bağlantı matrisi

```text
Internet → ALB 443               PASS
Internet → ECS task 8080         BLOCK
Internet → RDS 5432              BLOCK
ALB SG → ECS SG 8080             PASS
ECS SG → RDS SG 5432             PASS
ECS → ECR image pull             PASS
ECS → CloudWatch Logs            PASS
ECS → Secrets Manager            PASS
```
