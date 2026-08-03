# CloudForge Terraform Foundation

Bu klasör CloudForge AWS altyapısının Terraform kodlarını içerir.

## Yapı

```text
infrastructure/terraform/
├── bootstrap/
├── environments/
│   └── development/
├── modules/
│   └── vpc/
├── scripts/
└── Makefile
```

## İlk hedef

1. Terraform state için versioning ve encryption açık S3 bucket oluşturmak.
2. Development ortamında iki Availability Zone kullanan VPC temelini kurmak.
3. Public, private application ve isolated data subnetlerini oluşturmak.
4. ALB, ECS ve RDS için Security Group temelini hazırlamak.
5. NAT Gateway, ALB, ECS ve RDS gibi ücretli çalışma kaynaklarını henüz oluşturmamak.

## Komutlar

Repository kökünden:

```bash
make -C infrastructure/terraform help
```

Ön kontrol:

```bash
make -C infrastructure/terraform preflight
```

Bootstrap:

```bash
make -C infrastructure/terraform bootstrap-init
make -C infrastructure/terraform bootstrap-plan
make -C infrastructure/terraform bootstrap-apply
```

Development VPC:

```bash
make -C infrastructure/terraform dev-init
make -C infrastructure/terraform dev-plan
make -C infrastructure/terraform dev-apply
```

## Güvenlik

- Root kullanıcı access key'i kullanılmaz.
- AWS credential dosyaları repository'ye eklenmez.
- `terraform.tfvars` ve `backend.hcl` Git tarafından takip edilmez.
- State bucket silmeye karşı korunur.
- RDS Security Group yalnızca ECS Security Group'tan PostgreSQL trafiği kabul eder.
