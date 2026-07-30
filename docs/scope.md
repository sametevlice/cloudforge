# Proje Kapsamı

## Kapsam içindeki özellikler

### Platform

- Kullanıcı kaydı ve giriş
- JWT tabanlı authentication
- Kullanıcıya ait uygulamaların yönetimi
- GitHub repository bilgilerinin kaydedilmesi
- Uygulama yapılandırmasının doğrulanması
- Deployment başlatma
- Deployment geçmişi
- Deployment logları
- Manuel rollback
- Alert geçmişi

### CI/CD

- GitHub Actions ile test
- Maven build
- Docker image build
- Trivy güvenlik taraması
- Amazon ECR push
- Jenkins ile staging deployment
- Jenkins ile production deployment
- Health check
- Integration test
- Deployment sonucunun CloudForge'a bildirilmesi

### AWS

- VPC
- Public ve private subnetler
- Security Group
- Amazon ECR
- Amazon ECS Fargate
- Application Load Balancer
- Amazon RDS PostgreSQL
- AWS Secrets Manager
- CloudWatch Logs
- IAM roller
- Route 53 ve HTTPS, uygun aşamada

### Infrastructure as Code

- Terraform modülleri
- Development, staging ve production ortamları
- Remote state
- State locking
- Terraform validation
- TFLint
- Checkov

### Observability

- Prometheus
- Grafana
- Application metrikleri
- Infrastructure metrikleri
- Deployment metrikleri
- Alert kuralları
- CloudWatch logları

### Reliability

- Blue-green deployment
- Manuel rollback
- Health tabanlı rollback
- Metrik tabanlı otomatik rollback
- ECS Auto Scaling
- Load testing

### Akademik çalışma

- Rolling ve blue-green deployment karşılaştırması
- Performans ölçümleri
- Kesinti ölçümleri
- Rollback süresi ölçümleri
- AWS maliyet analizi

## İlk sürümde kapsam dışı özellikler

Aşağıdaki özellikler ana proje tamamlandıktan sonra zaman kalırsa değerlendirilecektir:

- Amazon EKS ve Kubernetes
- Çoklu cloud desteği
- Çoklu AWS hesabı
- GitHub dışındaki Git sağlayıcıları
- Faturalandırma sistemi
- Marketplace
- Her programlama dilini otomatik algılama
- Tam özellikli log analytics sistemi
- Mobil uygulama
- Enterprise seviyede multi-tenancy izolasyonu

## Desteklenen uygulama sözleşmesi

İlk sürümde deploy edilecek uygulama repository'si aşağıdaki dosya ve endpoint'leri sağlamalıdır:

- `Dockerfile`
- `.cloudforge.yml`
- Health endpoint
- Prometheus metrics endpoint
- Uygulama portu
- Build ve çalışma talimatları

Bu yaklaşım, sistemin kontrol edilebilir ve uygulanabilir kalmasını sağlar.
