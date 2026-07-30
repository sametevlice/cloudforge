# Başarı Kriterleri

CloudForge aşağıdaki kriterleri karşıladığında proje teknik olarak başarılı kabul edilecektir.

## Temel kriterler

- [ ] Kullanıcı platforma kayıt olabilir.
- [ ] Kullanıcı giriş yapabilir.
- [ ] Kullanıcı uygulama oluşturabilir.
- [ ] Kullanıcı GitHub repository bilgisi ekleyebilir.
- [ ] Repository yapılandırması doğrulanabilir.
- [ ] GitHub push işlemi CI pipeline'ını başlatır.
- [ ] Unit test başarısız olduğunda image oluşturulmaz.
- [ ] Docker image commit SHA ile etiketlenir.
- [ ] Image Amazon ECR'a gönderilir.
- [ ] Jenkins staging deployment gerçekleştirir.
- [ ] Staging health check başarısızsa production deployment yapılmaz.
- [ ] Jenkins production deployment gerçekleştirir.
- [ ] Uygulama ALB URL üzerinden erişilebilir.
- [ ] Loglar CloudWatch üzerinde görüntülenebilir.
- [ ] Prometheus uygulama metriklerini toplar.
- [ ] Grafana dashboard'ları metrikleri gösterir.
- [ ] Kullanıcı deployment geçmişini görebilir.
- [ ] Kullanıcı manuel rollback başlatabilir.
- [ ] Hatalı deployment otomatik rollback başlatabilir.
- [ ] Auto Scaling yük altında task sayısını artırabilir.
- [ ] RDS doğrudan internete açık değildir.
- [ ] AWS access key repository içinde tutulmaz.
- [ ] Terraform ile temel AWS altyapısı yeniden oluşturulabilir.

## Akademik kriterler

- [ ] Rolling deployment deneyi tamamlanır.
- [ ] Blue-green deployment deneyi tamamlanır.
- [ ] Deployment süreleri kaydedilir.
- [ ] Kesinti süreleri kaydedilir.
- [ ] HTTP hata oranları kaydedilir.
- [ ] Rollback süreleri kaydedilir.
- [ ] CPU ve bellek kullanımları karşılaştırılır.
- [ ] Maliyet değerlendirmesi yapılır.
- [ ] Bulgular grafik ve tablolarla sunulur.

## Yayın kriterleri

- [ ] GitHub README profesyonel biçimde hazırlanır.
- [ ] Mimari diyagramlar repository'de bulunur.
- [ ] Kurulum adımları belgelenir.
- [ ] Hata ve çözüm günlüğü tutulur.
- [ ] Demo videosu hazırlanır.
- [ ] Medium yazı serisi tamamlanır.
