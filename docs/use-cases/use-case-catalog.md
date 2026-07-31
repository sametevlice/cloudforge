# Use Case Catalog

## Aktörler

| Aktör | Açıklama |
|---|---|
| Platform User | Uygulamalarını yöneten standart kullanıcı |
| Administrator | CloudForge platformunu yöneten kullanıcı |
| GitHub | Kaynak kod ve CI sistemi |
| Jenkins | CD ve rollback sistemi |
| AWS | Çalışma ve altyapı platformu |
| Prometheus | Metrik toplama sistemi |

## Use case listesi

| Kod | Use case | Birincil aktör | Öncelik |
|---|---|---|---|
| UC-001 | Register account | Platform User | Must |
| UC-002 | Sign in | Platform User | Must |
| UC-003 | Create application | Platform User | Must |
| UC-004 | Validate repository | Platform User | Must |
| UC-005 | Provision application infrastructure | Platform User | Should |
| UC-006 | Run CI pipeline | GitHub | Must |
| UC-007 | Deploy to staging | Jenkins | Must |
| UC-008 | Deploy to production | Jenkins | Must |
| UC-009 | View deployment history | Platform User | Must |
| UC-010 | View deployment logs | Platform User | Must |
| UC-011 | View application metrics | Platform User | Must |
| UC-012 | Manage application secrets | Platform User | Should |
| UC-013 | Perform manual rollback | Platform User | Must |
| UC-014 | Perform automatic rollback | Jenkins | Should |
| UC-015 | Scale application | AWS | Should |
| UC-016 | Delete application | Platform User | Should |
| UC-017 | View platform overview | Administrator | Should |

## UC-003 — Create Application

**Amaç:** Kullanıcının CloudForge üzerinde uygulama kaydı oluşturması.

**Ön koşullar:** Kullanıcı giriş yapmış olmalıdır.

**Ana akış:**

1. Kullanıcı `New Application` ekranını açar.
2. Uygulama ve repository bilgilerini girer.
3. Port, health endpoint, kaynak ve scaling ayarlarını girer.
4. Sistem alanları doğrular.
5. Sistem uygulamayı `DRAFT` durumunda kaydeder.
6. Kullanıcı uygulama detay ekranına yönlendirilir.

**Alternatifler:**

- Geçersiz repository adresinde kayıt yapılmaz.
- Aynı slug varsa farklı slug istenir.
- Minimum task maksimumdan büyükse doğrulama hatası verilir.

**Son koşul:** Uygulama kaydı vardır fakat AWS kaynakları henüz oluşturulmamıştır.

## UC-005 — Provision Application Infrastructure

**Amaç:** Uygulama için AWS kaynaklarının otomatik oluşturulması.

**Yardımcı aktörler:** Jenkins, Terraform ve AWS.

**Ön koşullar:**

- Repository validation başarılıdır.
- Uygulama kullanıcıya aittir.
- Uygulama daha önce provision edilmemiştir.

**Ana akış:**

1. CloudForge provisioning kaydı oluşturur.
2. Jenkins pipeline tetiklenir.
3. Terraform validate ve plan çalışır.
4. ECR, ECS, target group, ALB rule ve log group oluşturulur.
5. Kaynaklar doğrulanır.
6. Sonuç CloudForge'a bildirilir.
7. Uygulama `READY` durumuna alınır.

**Hata akışı:** Hatalı kaynak ve aşama kaydedilir; işlem güvenli biçimde yeniden denenebilir.

## UC-008 — Deploy to Production

**Amaç:** Staging doğrulamasını geçen image'ın production'a dağıtılması.

**Ön koşullar:**

- CI başarılıdır.
- Image ECR'dadır.
- Staging health ve testleri başarılıdır.

**Ana akış:**

1. Yeni task definition revision oluşturulur.
2. Green sürüm hazırlanır.
3. Health ve smoke testleri çalıştırılır.
4. Gerekliyse onay alınır.
5. Trafik green sürüme geçirilir.
6. Prometheus metrikleri gözlenir.
7. Eşik ihlali yoksa deployment başarılı olur.

**Alternatif:** Trafik geçişinden sonra metrik ihlali oluşursa otomatik rollback çalışır.

## UC-013 — Perform Manual Rollback

**Amaç:** Kullanıcının daha önce başarılı olmuş sürüme dönmesi.

**Ön koşullar:**

- Hedef sürüm başarılı deployment olmalıdır.
- Image ECR'da bulunmalıdır.
- Kullanıcı uygulama sahibi veya admin olmalıdır.

**Ana akış:**

1. Kullanıcı deployment geçmişinden sürüm seçer.
2. Sistem etkileri gösterip onay ister.
3. Rollback kaydı açılır.
4. Jenkins hedef sürümü deploy eder.
5. Health ve smoke testleri yapılır.
6. Trafik eski sürüme geçirilir.
7. İşlem `ROLLED_BACK` olarak kaydedilir.
