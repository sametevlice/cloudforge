# Non-Functional Requirements

## Doküman bilgisi

| Alan | Değer |
|---|---|
| Proje | CloudForge |
| Doküman | Fonksiyonel Olmayan Gereksinimler |
| Sürüm | 1.0 |
| Durum | Taslak |
| İlgili görev | CF-005 |

## Güvenlik

### NFR-SEC-001

AWS anahtarları, parolalar, token'lar ve secret bilgiler repository içinde tutulmamalıdır.

### NFR-SEC-002

GitHub Actions AWS erişiminde OIDC tabanlı kısa ömürlü kimlik bilgileri kullanılmalıdır.

### NFR-SEC-003

Kullanıcı parolaları güçlü hashing algoritmasıyla saklanmalıdır.

### NFR-SEC-004

Her API isteğinde kullanıcı kimliği ve kaynak sahipliği doğrulanmalıdır.

### NFR-SEC-005

IAM rolleri least privilege prensibine uymalıdır.

### NFR-SEC-006

RDS doğrudan internetten erişilebilir olmamalıdır.

### NFR-SEC-007

Production kullanıcı trafiği HTTPS üzerinden taşınmalıdır.

### NFR-SEC-008

Secret değerleri uygulama, Jenkins veya CI loglarında görünmemelidir.

### NFR-SEC-009

Kritik güvenlik açığı olan image production'a deploy edilmemelidir.

### NFR-SEC-010

GitHub ve Jenkins webhook istekleri doğrulanmalıdır.

## Performans

### NFR-PERF-001

Normal yükte CloudForge API isteklerinin yüzde 95'i, harici uzun süreli işlemler hariç, 500 ms altında cevaplanmalıdır.

### NFR-PERF-002

Ana dashboard normal koşullarda 3 saniye içinde kullanılabilir hale gelmelidir.

### NFR-PERF-003

Loglar sayfalama veya streaming ile alınmalıdır.

### NFR-PERF-004

Deployment durumu arayüze hedef olarak en fazla 10 saniyelik gecikmeyle yansıtılmalıdır.

### NFR-PERF-005

Standart monitoring sorgularının çoğu 5 saniye içinde sonuç üretmelidir.

## Güvenilirlik

### NFR-REL-001

Production uygulamalarında health check zorunlu olmalıdır.

### NFR-REL-002

ECS sağlıksız task'ları otomatik değiştirebilmelidir.

### NFR-REL-003

Blue-green deployment sırasında algılanan kesinti sıfıra yakın olmalıdır.

### NFR-REL-004

Rollback kararı sonrası sistem hedef olarak 5 dakika içinde önceki sağlıklı sürüme dönmelidir.

### NFR-REL-005

CloudForge, Jenkins ve AWS durumları arasında tutarsızlık oluşursa tekrar kontrol yapabilmelidir.

### NFR-REL-006

Geçici ağ ve API hatalarında kontrollü retry uygulanmalıdır.

### NFR-REL-007

Provisioning ve deployment işlemleri yinelenen kaynak üretmeyecek şekilde idempotent tasarlanmalıdır.

## Ölçeklenebilirlik

### NFR-SCALE-001

Deploy edilen uygulamalar minimum ve maksimum task sınırları içinde yatay ölçeklenebilmelidir.

### NFR-SCALE-002

CloudForge backend mümkün olduğunca stateless olmalıdır.

### NFR-SCALE-003

Bir uygulamanın deployment veya scaling işlemi diğer uygulamaları etkilememelidir.

## Gözlemlenebilirlik

### NFR-OBS-001

Backend logları mümkün olduğunca structured formatta tutulmalıdır.

### NFR-OBS-002

Bir deployment isteği deployment ID veya correlation ID ile uçtan uca izlenebilmelidir.

### NFR-OBS-003

Sistem request rate, error rate, latency ve saturation metriklerini üretmelidir.

### NFR-OBS-004

Audit kayıtları teknik loglardan mantıksal olarak ayrılmalıdır.

### NFR-OBS-005

Tüm kayıtlar ortak zaman standardıyla saklanmalıdır.

## Bakım yapılabilirlik

### NFR-MAINT-001

Backend, frontend ve altyapı açık modül sınırlarına sahip olmalıdır.

### NFR-MAINT-002

Ortak AWS altyapısı Terraform ile yönetilmelidir.

### NFR-MAINT-003

Workflow ve Jenkinsfile source control içinde tutulmalıdır.

### NFR-MAINT-004

Lint, biçimlendirme ve test kontrolleri CI içinde çalışmalıdır.

### NFR-MAINT-005

Önemli modüller için kurulum ve hata ayıklama dokümantasyonu bulunmalıdır.

### NFR-MAINT-006

Önemli mimari kararlar ADR olarak kaydedilmelidir.

## Taşınabilirlik

### NFR-PORT-001

Uygulamalar OCI uyumlu Docker image olarak paketlenmelidir.

### NFR-PORT-002

Development, staging ve production ortamları ayrı yapılandırılmalıdır.

### NFR-PORT-003

Kritik dependency, action, provider ve base image sürümleri kontrol altında tutulmalıdır.

### NFR-PORT-004

Temel AWS altyapısı dokümantasyon ve Terraform ile yeniden oluşturulabilmelidir.

## Kullanılabilirlik

### NFR-UX-001

Uygulama ve deployment durumları anlaşılır ifadelerle gösterilmelidir.

### NFR-UX-002

Hata mesajları çözüm için faydalı açıklama içermelidir.

### NFR-UX-003

Silme, production deployment ve rollback için onay mekanizması bulunmalıdır.

### NFR-UX-004

Panel masaüstü ve tablet ekranlarında kullanılabilir olmalıdır.

## Maliyet

### NFR-COST-001

AWS kaynakları proje, ortam, uygulama ve yönetim yöntemi etiketlerine sahip olmalıdır.

### NFR-COST-002

Development kaynakları kullanılmadığında kapatılabilir veya kaldırılabilir olmalıdır.

### NFR-COST-003

Temel AWS kaynaklarının tahmini maliyetleri raporda belgelenmelidir.

## Test edilebilirlik

### NFR-TEST-001

Kritik backend servisleri için unit ve integration testleri bulunmalıdır.

### NFR-TEST-002

Terraform kodu format, validate, lint ve security scan kontrollerinden geçmelidir.

### NFR-TEST-003

Container kapanması, health hatası, HTTP 500 artışı ve deployment failure senaryoları test edilmelidir.

### NFR-TEST-004

Auto Scaling ve performans kontrollü yük testiyle değerlendirilmelidir.
