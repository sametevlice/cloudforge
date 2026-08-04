# AWS Demo Runtime

Development runtime güvenli varsayılan olarak kapalıdır.

## Aşama 1 — ECR

Mevcut `terraform.tfvars` ile:

```bash
make -C infrastructure/terraform dev-plan
make -C infrastructure/terraform dev-apply
```

Bu aşamada yalnızca yeni ECR repository eklenir.

## Aşama 2 — Image push

```bash
make -C infrastructure/terraform demo-push
```

Script commit SHA ile `linux/amd64` image üretir, ECR'a push eder ve
`runtime.auto.tfvars` oluşturur.

## Aşama 3 — Runtime plan/apply

```bash
make -C infrastructure/terraform dev-plan
make -C infrastructure/terraform dev-apply
```

Bu aşamada ALB, ECS cluster, RDS, CloudWatch Logs, IAM task rolleri,
task definition ve ECS service oluşturulur.

## Development network kararı

NAT Gateway maliyetini önlemek için ECS task development ortamında
public subnetlerde public IP alır. Security Group inbound erişimi yalnızca
Application Load Balancer'dan kabul eder. RDS private subnetlerde kalır.
