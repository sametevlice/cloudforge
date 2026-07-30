# ADR-002: GitHub Actions ve Jenkins Sorumluluklarının Ayrılması

## Durum

Kabul edildi.

## Bağlam

Projede hem GitHub Actions hem Jenkins kullanılacaktır. Aynı görevlerin iki araçta tekrar edilmesi gereksiz karmaşıklık oluşturur.

## Karar

GitHub Actions continuous integration görevlerinden, Jenkins ise continuous deployment görevlerinden sorumlu olacaktır.

## GitHub Actions sorumlulukları

- Kod checkout
- Unit test
- Integration test
- Maven package
- Docker build
- Güvenlik taraması
- Amazon ECR push
- Build sonucunu bildirme

## Jenkins sorumlulukları

- Staging deployment
- Health check
- Integration ve smoke test
- Production onayı
- Production deployment
- Blue-green trafik geçişi
- Deployment doğrulama
- Rollback
- Deployment sonucunu CloudForge backend'e bildirme

## Gerekçeler

- Araçların sorumlulukları açık olur.
- Pipeline hata ayıklaması kolaylaşır.
- CI ve CD güvenlik izinleri ayrılabilir.
- GitHub repository işlemleri GitHub Actions içinde kalır.
- AWS ortamları arası deployment Jenkins tarafından merkezi yönetilir.
