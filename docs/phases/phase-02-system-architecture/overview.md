# Aşama 2 — Sistem Mimarisi

## İlgili görev

CF-006 — Create high-level system architecture

## Amaç

CloudForge’un ana bileşenlerini, sorumluluklarını, veri akışlarını ve güven sınırlarını tanımlamak.

## Tamamlanan çalışmalar

- [x] Control Plane ve Workload Plane ayrımı tanımlandı.
- [x] Ana bileşenler belirlendi.
- [x] Bileşen sorumlulukları yazıldı.
- [x] Üst seviye mimari diyagram oluşturuldu.
- [x] Deployment sequence oluşturuldu.
- [x] Güven bölgeleri tanımlandı.
- [x] Modüler monolith kararı ADR olarak kaydedildi.
- [ ] AWS network mimarisi ayrıntılandırılacak.
- [ ] CI/CD diyagramı ayrıntılandırılacak.
- [ ] Veritabanı ER diyagramı hazırlanacak.

## Çıkış kriteri

- Her araç ve bileşenin tek ve anlaşılır sorumluluğu bulunmalıdır.
- CI ve CD sorumlulukları birbirine karışmamalıdır.
- Control Plane ile deploy edilen workload’lar ayrılmalıdır.
- Kritik güven sınırları belgelenmelidir.
