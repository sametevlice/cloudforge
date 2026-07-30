# CloudForge Proje Tanımı

## Proje adı

**CloudForge**

## Türkçe akademik başlık

**AWS Üzerinde Infrastructure as Code, CI/CD, Gözlemlenebilirlik ve Otomatik Hata Kurtarma Destekli Self-Service Bulut Dağıtım Platformunun Tasarlanması ve Gerçekleştirilmesi**

## İngilizce akademik başlık

**Design and Implementation of a Self-Service Cloud Deployment Platform with Infrastructure as Code, CI/CD, Observability and Automated Failure Recovery on AWS**

## Proje özeti

CloudForge, geliştiricilerin GitHub repository'lerinde bulunan uygulamalarını AWS üzerine otomatik olarak dağıtmalarını sağlayan self-service bir bulut platformudur.

Platform; kaynak kod testlerini, Docker image üretimini, güvenlik taramalarını, image registry işlemlerini, staging ve production deployment süreçlerini, uygulama metriklerinin izlenmesini ve hatalı sürümlerde rollback işlemlerini otomatikleştirmeyi amaçlar.

Kullanıcı, CloudForge web panelinden GitHub repository bilgisini ve uygulama yapılandırmasını girer. Sistem, GitHub Actions ile continuous integration işlemlerini gerçekleştirir. Başarılı build sonucunda Docker image Amazon ECR'a gönderilir. Jenkins, image'ı Amazon ECS Fargate üzerine deploy eder. Prometheus ve Grafana uygulama ile altyapı metriklerini izler. Hatalı sürüm tespit edildiğinde sistem önceki sağlıklı sürüme geri dönebilir.

## Projenin amacı

Projenin temel amacı; modern DevOps, cloud computing ve site reliability engineering yaklaşımlarını tek bir gerçek sistem içinde birleştiren, tekrar üretilebilir, güvenli, izlenebilir ve otomatik bir deployment platformu geliştirmektir.

## Projenin akademik değeri

Proje yalnızca çalışan bir yazılım geliştirmeyi değil, farklı deployment yöntemlerinin deneysel olarak karşılaştırılmasını da kapsar.

Rolling ve blue-green deployment yöntemleri aşağıdaki ölçütler üzerinden karşılaştırılacaktır:

- Deployment süresi
- Kesinti süresi
- Başarısız HTTP istek sayısı
- HTTP 5xx oranı
- P95 response time
- Rollback süresi
- CPU ve bellek tüketimi
- Tahmini AWS maliyeti

## Hedef kullanıcılar

- Yazılım geliştiriciler
- Öğrenci geliştiriciler
- Küçük yazılım ekipleri
- DevOps öğrenen kullanıcılar
- Uygulamasını AWS üzerinde yayınlamak isteyen geliştiriciler

## Ana kullanıcı senaryosu

1. Kullanıcı CloudForge'a giriş yapar.
2. GitHub repository adresini ekler.
3. Uygulamanın port, health path, CPU ve bellek ayarlarını tanımlar.
4. CloudForge repository yapılandırmasını doğrular.
5. GitHub Actions test, build ve güvenlik taraması yapar.
6. Docker image Amazon ECR'a gönderilir.
7. Jenkins staging deployment başlatır.
8. Health ve integration testleri başarılı olursa production deployment yapılır.
9. Kullanıcı canlı uygulama URL'sini alır.
10. Prometheus ve Grafana metrikleri gösterir.
11. Hatalı sürüm oluşursa manuel veya otomatik rollback yapılır.
