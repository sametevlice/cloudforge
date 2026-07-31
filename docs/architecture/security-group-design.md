# Security Group Design

Security Group'lar stateful çalışır; izin verilen bağlantının dönüş trafiği ayrıca inbound kuralı gerektirmez.

## `cloudforge-alb-sg`

### Inbound

| Port | Kaynak | Amaç |
|---|---|---|
| 80/TCP | `0.0.0.0/0` | HTTPS redirect |
| 443/TCP | `0.0.0.0/0` | Public HTTPS |

### Outbound

| Port | Hedef |
|---|---|
| Application port | `cloudforge-ecs-task-sg` |

## `cloudforge-ecs-task-sg`

### Inbound

| Port | Kaynak | Amaç |
|---|---|---|
| 8080/TCP | `cloudforge-alb-sg` | Application traffic |
| 8080/TCP | `cloudforge-monitoring-sg` | Metrics scrape — gerekiyorsa |

### Outbound

- HTTPS `443/TCP` — ECR, Logs, Secrets Manager veya NAT
- PostgreSQL `5432/TCP` — RDS SG
- DNS `53/TCP+UDP` — VPC resolver

Başlangıçta outbound geniş tutulabilir; güvenlik sertleştirme aşamasında daraltılır.

## `cloudforge-rds-sg`

### Inbound

| Port | Kaynak |
|---|---|
| 5432/TCP | `cloudforge-ecs-task-sg` |
| 5432/TCP | `cloudforge-management-sg` — yalnızca gerekiyorsa |

## `cloudforge-management-sg`

Doğrudan public SSH veya Jenkins 8080 inbound kuralı eklenmez. SSM, VPN veya internal access kullanılır.

## Yasaklanan kurallar

```text
RDS 5432 from 0.0.0.0/0
Jenkins 8080 from 0.0.0.0/0
SSH 22 from 0.0.0.0/0
ECS application port from 0.0.0.0/0
```
