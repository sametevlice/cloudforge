# Trust Boundaries and Security Zones

## Amaç

CloudForge içindeki güven bölgelerini ve sınırlar arası geçişleri tanımlamak.

## Güven bölgeleri

### Zone 1 — Public Internet

İçerir:

- CloudForge kullanıcıları
- Deploy edilen uygulamaların son kullanıcıları
- GitHub webhook çağrıları

Bu bölgeden gelen bütün trafik güvenilmeyen trafik kabul edilir.

### Zone 2 — Public Entry Layer

İçerir:

- CloudForge frontend erişimi
- Application Load Balancer
- HTTPS endpoint’leri

Kontroller:

- TLS
- Authentication
- Rate limiting
- Webhook signature validation
- Security Group kuralları

### Zone 3 — CloudForge Control Plane

İçerir:

- Spring Boot backend
- Jenkins
- Platform database
- Monitoring yönetim bileşenleri

Kontroller:

- IAM role
- Network kısıtlaması
- RBAC
- Audit logging
- Secret masking
- Minimum inbound erişim

### Zone 4 — Application Workload Plane

İçerir:

- ECS task’ları
- Uygulama database bağlantıları
- Uygulama secret’ları
- Application metrics endpoint’leri

Kontroller:

- Uygulama bazlı IAM task role
- ALB dışından inbound trafiğin engellenmesi
- Database Security Group ayrımı
- Secret scope sınırı

### Zone 5 — External SaaS

İçerir:

- GitHub
- GitHub Actions runners

Kontroller:

- OIDC
- Minimum GitHub workflow permissions
- Repository branch protection
- Webhook doğrulama

## Temel güvenlik kuralları

1. Frontend AWS credential taşımaz.
2. GitHub Actions uzun ömürlü AWS anahtarına ihtiyaç duymaz.
3. Jenkins IAM role yalnızca deployment için gerekli izinlere sahip olur.
4. RDS public erişime açılmaz.
5. ECS task Security Group yalnızca ALB’den gelen application portuna izin verir.
6. Secret değeri CloudForge response veya loglarında dönmez.
7. Kullanıcı, başka kullanıcının deployment ID’siyle işlem yapamaz.
