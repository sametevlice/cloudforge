# Route Table Design

## Public route table

| Destination | Target |
|---|---|
| `10.20.0.0/16` | `local` |
| `0.0.0.0/0` | Internet Gateway |

## Private application A

| Destination | Target |
|---|---|
| `10.20.0.0/16` | `local` |
| `0.0.0.0/0` | NAT Gateway A |
| S3 prefix list | S3 Gateway Endpoint — etkinse |

## Private application B

| Destination | Target |
|---|---|
| `10.20.0.0/16` | `local` |
| `0.0.0.0/0` | NAT Gateway B |
| S3 prefix list | S3 Gateway Endpoint — etkinse |

## Private data

| Destination | Target |
|---|---|
| `10.20.0.0/16` | `local` |

Data subnetlerinde `0.0.0.0/0` rotası bulunmaz.

## Development profili

NAT kapalıysa ECS task'ları public subnetlerde çalışır ve `assign_public_ip = true` kullanır. RDS private subnetlerde kalır.
