# ADR-001: Ana Container Orchestration Sistemi Olarak ECS Fargate Kullanılması

## Durum

Kabul edildi.

## Bağlam

CloudForge'un container uygulamalarını AWS üzerinde çalıştırması gerekir. Amazon ECS Fargate ve Amazon EKS temel seçeneklerdir.

EKS daha geniş Kubernetes yetenekleri sunmasına rağmen cluster yönetimi, networking, observability ve maliyet bakımından projenin ilk sürümünde önemli ek karmaşıklık oluşturacaktır.

## Karar

CloudForge'un ana ve zorunlu container orchestration sistemi Amazon ECS Fargate olacaktır.

Amazon EKS desteği yalnızca ana sistem tamamlandıktan sonra opsiyonel geliştirme olarak değerlendirilecektir.

## Gerekçeler

- AWS servisleriyle doğrudan entegrasyon
- Sunucu işletim sistemi yönetiminin azaltılması
- ECS task ve service modelinin proje kapsamına uygun olması
- Application Load Balancer entegrasyonu
- Auto Scaling desteği
- Blue-green deployment uygulama imkânı
- Bitirme projesinin platform geliştirme kısmına daha fazla zaman ayırabilme

## Sonuçlar

### Olumlu

- İlk çalışan sürüme daha hızlı ulaşılır.
- Altyapı karmaşıklığı kontrol altında tutulur.
- Platform, CI/CD ve observability özelliklerine daha fazla odaklanılır.

### Olumsuz

- Kubernetes tabanlı taşınabilirlik ilk sürümde bulunmaz.
- EKS deneyimi zorunlu proje çıktısı olmaz.
