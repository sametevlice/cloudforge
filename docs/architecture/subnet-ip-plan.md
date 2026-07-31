# Subnet and IP Address Plan

## VPC

```text
Name: cloudforge-vpc
CIDR: 10.20.0.0/16
Region: eu-central-1
```

## Subnet tablosu

| Terraform adı | CIDR | AZ | Tür | Kaynaklar |
|---|---:|---|---|---|
| `public_a` | `10.20.0.0/24` | AZ A | Public | ALB, NAT A |
| `public_b` | `10.20.1.0/24` | AZ B | Public | ALB, NAT B |
| `app_private_a` | `10.20.10.0/24` | AZ A | Private | ECS task |
| `app_private_b` | `10.20.11.0/24` | AZ B | Private | ECS task |
| `data_private_a` | `10.20.20.0/24` | AZ A | Isolated private | RDS subnet group |
| `data_private_b` | `10.20.21.0/24` | AZ B | Isolated private | RDS subnet group |
| `management_private_a` | `10.20.30.0/24` | AZ A | Private | Jenkins, monitoring |
| `management_private_b` | `10.20.31.0/24` | AZ B | Private | Future management |

## Terraform giriş taslağı

```hcl
vpc_cidr = "10.20.0.0/16"

public_subnet_cidrs = [
  "10.20.0.0/24",
  "10.20.1.0/24"
]

private_app_subnet_cidrs = [
  "10.20.10.0/24",
  "10.20.11.0/24"
]

private_data_subnet_cidrs = [
  "10.20.20.0/24",
  "10.20.21.0/24"
]

private_management_subnet_cidrs = [
  "10.20.30.0/24",
  "10.20.31.0/24"
]
```
