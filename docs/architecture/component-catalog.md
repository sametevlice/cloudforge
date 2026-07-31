# Component Catalog

## Amaç

Bu doküman CloudForge bileşenlerinin sorumluluklarını ve iletişim biçimlerini özetler.

| Bileşen | Teknoloji | Ana sorumluluk | İletişim |
|---|---|---|---|
| Web UI | React + TypeScript | Kullanıcı arayüzü | HTTPS REST |
| Platform API | Java 21 + Spring Boot | İş kuralları ve orchestration | REST, webhook |
| Platform Database | PostgreSQL | Platform metadata | JDBC |
| Git Repository | GitHub | Kaynak kod yönetimi | Git, webhook |
| CI Engine | GitHub Actions | Test, build, scan ve ECR push | OIDC, HTTPS |
| CD Engine | Jenkins | Provisioning, deployment ve rollback | REST, AWS API |
| Container Registry | Amazon ECR | Immutable image saklama | Registry API |
| Container Runtime | ECS Fargate | Kullanıcı uygulamalarını çalıştırma | AWS API |
| Load Balancer | ALB | Routing, health ve trafik geçişi | HTTP/HTTPS |
| Application Database | RDS PostgreSQL | Demo uygulama verisi | PostgreSQL |
| Secret Store | Secrets Manager | Secret değerleri | AWS API |
| Metrics Store | Prometheus | Zaman serisi metrikleri | HTTP scrape |
| Dashboard | Grafana | Metrik görselleştirme | PromQL |
| Log Store | CloudWatch Logs | Container ve platform logları | AWS API |

## Bağımlılık kuralları

1. Frontend yalnızca Platform API ile iletişim kurar.
2. Platform API doğrudan container image oluşturmaz.
3. GitHub Actions doğrudan production trafik geçişi yapmaz.
4. Jenkins kaynak kod kalite kontrolünün ana sahibi değildir.
5. Gerçek secret değerleri Platform Database içinde tutulmaz.
6. ECS task’ları CloudForge backend veritabanına doğrudan bağlanmaz.
7. Kullanıcı uygulamaları birbirlerinin target group, service veya secret kaynaklarına erişmez.
