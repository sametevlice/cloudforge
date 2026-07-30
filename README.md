# CloudForge

CloudForge; GitHub üzerindeki uygulamaların otomatik olarak test edilmesini, Docker image haline getirilmesini, Amazon ECR'a gönderilmesini, AWS ECS Fargate üzerine dağıtılmasını, Prometheus ve Grafana ile izlenmesini ve hatalı sürümlerde rollback yapılmasını sağlayan self-service bir cloud deployment platformudur.

## Proje durumu

**Aşama 0 — Proje Organizasyonu**

## Temel hedef

Bir kullanıcı:

1. GitHub repository adresini CloudForge'a ekler.
2. Uygulama ayarlarını tanımlar.
3. CI pipeline kodu test eder ve Docker image üretir.
4. Image Amazon ECR'a gönderilir.
5. Jenkins uygulamayı staging ve production ortamlarına deploy eder.
6. Prometheus ve Grafana uygulamayı izler.
7. Hatalı deployment durumunda sistem eski sürüme döner.

## Ana teknolojiler

- Java 21
- Spring Boot
- React
- TypeScript
- PostgreSQL
- Docker
- AWS
- Amazon ECS Fargate
- Amazon ECR
- Amazon RDS
- Application Load Balancer
- Terraform
- GitHub Actions
- Jenkins
- Prometheus
- Grafana
- CloudWatch

## Repository planı

CloudForge dört ana repository üzerinden geliştirilecektir:

- `cloudforge-platform`
- `cloudforge-infrastructure`
- `cloudforge-demo-app`
- `cloudforge-documentation`

Bu başlangıç repository'si proje organizasyonu ve dokümantasyon iskeletini içerir.

## Dokümantasyon

- [Proje tanımı](docs/project-definition.md)
- [Problem tanımı](docs/problem-statement.md)
- [Kapsam](docs/scope.md)
- [Yol haritası](docs/roadmap.md)
- [Başarı kriterleri](docs/success-criteria.md)
- [GitHub issue listesi](docs/github-issues.md)
- [ADR-001: ECS Fargate seçimi](docs/adr/ADR-001-ecs-fargate.md)
- [ADR-002: GitHub Actions ve Jenkins ayrımı](docs/adr/ADR-002-ci-cd-separation.md)

## Akademik ve yayın hedefi

Proje aşağıdaki çıktıları üretecek:

- Bitirme projesi raporu
- Kaynak kodları ve profesyonel GitHub README dosyaları
- Mimari diyagramlar
- Deney ve performans sonuçları
- AWS maliyet analizi
- Demo videosu
- Sunum
- Medium yazı serisi

## Lisans

Lisans kararı proje ilerleyen aşamalarında verilecektir.
