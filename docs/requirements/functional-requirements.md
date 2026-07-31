# Functional Requirements

## Doküman bilgisi

| Alan | Değer |
|---|---|
| Proje | CloudForge |
| Doküman | Fonksiyonel Gereksinimler |
| Sürüm | 1.0 |
| Durum | Taslak |
| İlgili görev | CF-004 |

## Amaç

Bu doküman CloudForge platformunun kullanıcıya, yöneticiye ve bağlı sistemlere sunması gereken işlevleri tanımlar.

## Aktörler

- **Platform User:** Uygulama oluşturan, deploy eden ve izleyen kullanıcı.
- **Administrator:** Platformun genel durumunu ve kullanıcılarını yöneten kişi.
- **GitHub:** Kaynak kod ve GitHub Actions CI sistemi.
- **Jenkins:** Staging, production ve rollback süreçlerini yöneten CD sistemi.
- **AWS:** Uygulamaların çalıştığı cloud platformu.
- **Prometheus:** Uygulama ve deployment metriklerini toplayan sistem.
- **Grafana:** Metrikleri dashboard üzerinde gösteren sistem.

## Authentication ve kullanıcı yönetimi

### FR-AUTH-001 — Kullanıcı kaydı

Sistem, yeni bir kullanıcının ad, e-posta ve parola bilgileriyle hesap oluşturmasına izin vermelidir.

**Kabul kriterleri:**

- E-posta benzersiz olmalıdır.
- Parola düz metin olarak saklanmamalıdır.
- Geçersiz alanlar kullanıcıya açıklanmalıdır.

### FR-AUTH-002 — Kullanıcı girişi

Kayıtlı kullanıcı e-posta ve parola bilgileriyle giriş yapabilmelidir.

### FR-AUTH-003 — Kaynak sahipliği

Kullanıcı yalnızca kendisine ait uygulama, deployment, secret ve alarm kayıtlarına erişebilmelidir.

### FR-AUTH-004 — Oturum sonlandırma

Kullanıcı mevcut oturumunu güvenli şekilde sonlandırabilmelidir.

### FR-AUTH-005 — Roller

Sistem en az `USER` ve `ADMIN` rollerini desteklemelidir.

## Uygulama yönetimi

### FR-APP-001 — Uygulama oluşturma

Kullanıcı aşağıdaki bilgilerle uygulama oluşturabilmelidir:

- Uygulama adı ve slug
- GitHub repository adresi
- Branch
- Container portu
- Health ve metrics endpoint
- CPU ve bellek
- Minimum ve maksimum task sayısı

### FR-APP-002 — Uygulama listeleme

Kullanıcı kendisine ait uygulamaları listeleyebilmelidir.

### FR-APP-003 — Uygulama detayı

Kullanıcı yapılandırma, çalışma durumu, URL, aktif sürüm ve son deployment bilgilerini görebilmelidir.

### FR-APP-004 — Uygulama güncelleme

Kullanıcı branch, kaynak, endpoint ve scaling ayarlarını güncelleyebilmelidir.

### FR-APP-005 — Uygulama silme

Kullanıcı uygulamasını kontrollü bir onay mekanizmasıyla silebilmelidir.

### FR-APP-006 — Uygulama durumları

Sistem en az şu durumları desteklemelidir:

`DRAFT`, `VALIDATING`, `READY`, `PROVISIONING`, `RUNNING`, `DEGRADED`, `FAILED`, `DELETING`, `DELETED`.

## Repository doğrulama

### FR-REP-001 — Repository adresi

Girilen adres geçerli GitHub repository formatında olmalıdır.

### FR-REP-002 — Branch doğrulama

Belirtilen branch repository içinde bulunmalıdır.

### FR-REP-003 — Dockerfile doğrulama

Repository içinde tanımlanan konumda `Dockerfile` bulunmalıdır.

### FR-REP-004 — CloudForge yapılandırması

Repository kökünde `.cloudforge.yml` dosyası desteklenmelidir.

### FR-REP-005 — Şema doğrulama

`.cloudforge.yml` alanları tanımlı şemaya göre doğrulanmalıdır.

### FR-REP-006 — Health endpoint

Deployment öncesi health endpoint tanımlanmış olmalıdır.

### FR-REP-007 — Metrics endpoint

Monitoring etkinse metrics endpoint tanımlanmalıdır.

## Provisioning

### FR-PROV-001 — Provisioning başlatma

Kullanıcı doğrulanmış uygulama için provisioning başlatabilmelidir.

### FR-PROV-002 — ECR repository

Sistem uygulama için Amazon ECR repository oluşturabilmelidir.

### FR-PROV-003 — ECS kaynakları

Sistem ECS task definition ve ECS service kaynaklarını oluşturabilmelidir.

### FR-PROV-004 — ALB routing

Sistem target group ve Application Load Balancer routing kuralı oluşturabilmelidir.

### FR-PROV-005 — Log grubu

Her uygulama için CloudWatch Log Group oluşturulmalıdır.

### FR-PROV-006 — Secret altyapısı

AWS Secrets Manager bağlantısı oluşturulabilmelidir.

### FR-PROV-007 — Provisioning takibi

Kullanıcı provisioning aşamalarını ve sonucunu görebilmelidir.

### FR-PROV-008 — Provisioning hatası

Hata mesajı, başarısız aşama ve mümkünse çözüm önerisi kaydedilmelidir.

## Continuous Integration

### FR-CI-001 — Pipeline tetikleme

Desteklenen branch'lere push veya pull request geldiğinde GitHub Actions başlamalıdır.

### FR-CI-002 — Testler

Pipeline unit ve integration testlerini çalıştırmalıdır.

### FR-CI-003 — Build

Testler başarılı olduğunda uygulama build edilmelidir.

### FR-CI-004 — Docker build

Geçerli Dockerfile ile image oluşturulmalıdır.

### FR-CI-005 — Image etiketi

Image en az Git commit SHA ile etiketlenmelidir.

### FR-CI-006 — Güvenlik taraması

Image vulnerability taramasından geçirilmelidir.

### FR-CI-007 — Kritik açık engeli

Kritik güvenlik açığı production sürecini durdurabilmelidir.

### FR-CI-008 — ECR push

Başarılı image Amazon ECR'a gönderilmelidir.

### FR-CI-009 — CI sonucu

CI sonucu CloudForge backend'e veya GitHub kontrolüne bildirilmelidir.

## Continuous Deployment

### FR-CD-001 — Deployment başlatma

Kullanıcı panelden veya başarılı CI sonrasında deployment başlatabilmelidir.

### FR-CD-002 — Staging deployment

Yeni image önce staging ortamına deploy edilmelidir.

### FR-CD-003 — Staging health check

Health check geçmeden production deployment yapılmamalıdır.

### FR-CD-004 — Smoke ve integration testleri

Staging ortamında tanımlı testler çalıştırılmalıdır.

### FR-CD-005 — Production onayı

Yapılandırılabilir manuel onay adımı desteklenmelidir.

### FR-CD-006 — Production deployment

Başarılı doğrulama sonrası production deployment yapılmalıdır.

### FR-CD-007 — Deployment kaydı

Uygulama, ortam, commit SHA, image tag, önceki image, zamanlar, durum, hata ve strateji kaydedilmelidir.

### FR-CD-008 — Deployment durumları

`PENDING`, `BUILDING`, `BUILD_FAILED`, `IMAGE_PUSHED`, `DEPLOYING_STAGING`, `STAGING_FAILED`, `WAITING_APPROVAL`, `DEPLOYING_PRODUCTION`, `VERIFYING`, `SUCCESSFUL`, `FAILED`, `ROLLING_BACK`, `ROLLED_BACK`.

### FR-CD-009 — Canlı durum

Kullanıcı deployment aşamalarını güncel şekilde görebilmelidir.

## Blue-green ve rollback

### FR-REL-001 — Blue-green deployment

Production ortamı blue-green deployment desteklemelidir.

### FR-REL-002 — Green doğrulama

Yeni sürüm trafik almadan health ve smoke testlerinden geçmelidir.

### FR-REL-003 — Trafik geçişi

Başarılı doğrulama sonrası trafik blue sürümden green sürüme aktarılmalıdır.

### FR-REL-004 — Manuel rollback

Kullanıcı daha önce başarılı olmuş sürüme rollback yapabilmelidir.

### FR-REL-005 — Otomatik rollback

Sağlık veya metrik eşikleri aşıldığında otomatik rollback başlatılabilmelidir.

### FR-REL-006 — Rollback kaydı

Rollback ayrı deployment olayı olarak kaydedilmelidir.

## Monitoring ve logging

### FR-OBS-001 — Application metrics

Prometheus request, hata ve response time metriklerini toplamalıdır.

### FR-OBS-002 — Infrastructure metrics

CPU, bellek, running task ve ALB metrikleri görüntülenebilmelidir.

### FR-OBS-003 — Grafana dashboard

İlgili Grafana dashboard'una erişilebilmelidir.

### FR-OBS-004 — Log görüntüleme

Uygulama CloudWatch logları görüntülenebilmelidir.

### FR-OBS-005 — Deployment metrics

Deployment süresi, başarı oranı ve rollback sayısı üretilmelidir.

### FR-OBS-006 — Alert oluşturma

Tanımlı eşikler aşıldığında alarm kaydı oluşturulmalıdır.

## Secret yönetimi

### FR-SEC-001 — Secret oluşturma

Kullanıcı uygulaması için secret tanımlayabilmelidir.

### FR-SEC-002 — Secret gizleme

Kaydedilen secret değerleri arayüz veya API yanıtında tekrar gösterilmemelidir.

### FR-SEC-003 — Secrets Manager

Gerçek değerler AWS Secrets Manager'da tutulmalıdır.

### FR-SEC-004 — Metadata

CloudForge yalnızca secret adı, ARN ve uygulama ilişkisini saklamalıdır.

## Auto Scaling

### FR-SCALE-001 — Scaling sınırları

Kullanıcı minimum ve maksimum task sayısını tanımlayabilmelidir.

### FR-SCALE-002 — CPU tabanlı scaling

CPU kullanımına göre task sayısı otomatik değişebilmelidir.

### FR-SCALE-003 — Scaling olayları

Kullanıcı task değişikliklerini ve nedenlerini görebilmelidir.

## Audit ve yönetim

### FR-AUD-001 — Audit log

Giriş, uygulama oluşturma/silme, provisioning, deployment, rollback ve secret işlemleri kaydedilmelidir.

### FR-AUD-002 — Administrator dashboard

Administrator toplam kullanıcı, uygulama, deployment, hata ve alarm sayılarını görebilmelidir.

## MoSCoW önceliği

### Must Have

Authentication, uygulama yönetimi, repository validation, GitHub Actions CI, ECR, Jenkins CD, ECS Fargate, deployment history, Prometheus, Grafana, manuel rollback ve Terraform.

### Should Have

Self-service provisioning, blue-green deployment, otomatik rollback, Secrets Manager, Auto Scaling ve alert sistemi.

### Could Have

GitHub App, canary deployment, bildirimler, OpenTelemetry ve Grafana Loki.

### Won't Have — İlk sürüm

Çoklu cloud, zorunlu Kubernetes, marketplace, faturalandırma ve enterprise multi-tenancy.
