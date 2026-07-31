# ADR-003: CloudForge Backend İçin Modüler Monolith Kullanılması

## Durum

Kabul edildi.

## Bağlam

CloudForge authentication, application management, provisioning, deployment, monitoring, alert ve audit gibi birden fazla iş alanına sahiptir.

Bu alanların ayrı mikroservislere bölünmesi mümkündür. Ancak bitirme projesinin tek geliştirici tarafından tamamlanacak olması; servis discovery, dağıtık transaction, ağ hataları, çoklu deployment pipeline ve ek monitoring yükünü gereksiz biçimde artırabilir.

## Karar

CloudForge platform backend’i ilk sürümde Spring Boot tabanlı modüler monolith olarak geliştirilecektir.

Her iş alanı ayrı package/modül sınırına sahip olacaktır:

```text
com.cloudforge
├── auth
├── user
├── application
├── repository
├── provisioning
├── deployment
├── secret
├── monitoring
├── alert
├── audit
└── integration
```

Modüller birbirlerinin internal sınıflarına doğrudan erişmek yerine açık service ve event sınırlarını kullanmalıdır.

## Gerekçeler

- Tek repository ve tek deployment birimi
- Daha kolay local geliştirme
- Daha kolay transaction yönetimi
- Daha düşük AWS maliyeti
- Daha hızlı test ve hata ayıklama
- İş alanlarının yine de açık biçimde ayrılabilmesi

## Sonuçlar

### Olumlu

- Platform daha hızlı geliştirilebilir.
- CI/CD ve monitoring karmaşıklığı azalır.
- Bitirme projesinin esas konusu olan DevOps otomasyonuna daha fazla zaman ayrılır.

### Olumsuz

- Backend modülleri bağımsız ölçeklenemez.
- Modül sınırları disiplinli uygulanmazsa kod sıkı bağlı hale gelebilir.
- Gelecekte mikroservise ayrılacak alanlar için refactoring gerekebilir.

## Gelecekte yeniden değerlendirme koşulları

Aşağıdaki durumlardan biri oluşursa servis ayrımı değerlendirilebilir:

- Deployment modülü platformun geri kalanından bağımsız ölçeklenmek zorunda kalırsa
- Monitoring sorguları API performansını ciddi etkilerse
- Çoklu ekip yapısına geçilirse
- Farklı modüllerin farklı yayın hızları gerekirse
