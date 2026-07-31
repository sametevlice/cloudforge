# Development and Production Network Profiles

## Production-like

```hcl
network_profile          = "production-like"
enable_nat_gateway       = true
nat_gateway_per_az       = true
ecs_assign_public_ip     = false
enable_vpc_flow_logs     = true
```

- ECS private subnetlerde
- İki NAT Gateway
- RDS private
- Daha yüksek dayanıklılık ve maliyet

## Cost-saving development

```hcl
network_profile          = "cost-saving"
enable_nat_gateway       = false
nat_gateway_per_az       = false
ecs_assign_public_ip     = true
enable_vpc_flow_logs     = false
```

- ALB iki public subnet kullanır.
- ECS task'ları public IP alabilir.
- ECS inbound yalnızca ALB SG'den gelir.
- RDS private kalır.
- Yalnızca development ve kontrollü demo içindir.

## Single NAT test profili

```hcl
network_profile          = "single-nat"
enable_nat_gateway       = true
nat_gateway_per_az       = false
ecs_assign_public_ip     = false
```

Bu profil kısa testler için kullanılabilir; production için önerilmez.

| Profil | Güvenlik | Erişilebilirlik | Maliyet | Kullanım |
|---|---|---|---|---|
| Cost-saving | Orta | Orta | Düşük | Development demo |
| Single NAT | İyi | Orta | Orta | Kısa test |
| Production-like | İyi | Yüksek | Yüksek | Final demo ve deney |
