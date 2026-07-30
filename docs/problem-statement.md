# Problem Tanımı

Modern bir uygulamayı production ortamına taşımak yalnızca kaynak kodu bir sunucuya kopyalamaktan ibaret değildir.

Bir geliştiricinin aşağıdaki işlemleri doğru ve güvenli şekilde gerçekleştirmesi gerekir:

- Uygulamayı test etmek
- Uygulamayı container haline getirmek
- Container image'ını güvenli şekilde saklamak
- Network ve erişim kurallarını oluşturmak
- Uygulamayı ölçeklenebilir bir ortamda çalıştırmak
- Log ve metrikleri toplamak
- Hatalı deployment durumunda eski sürüme dönmek
- Şifre ve erişim anahtarlarını güvenli biçimde yönetmek
- Aynı işlemleri tekrar edilebilir hale getirmek

Bu işlemler farklı araçlar ve servisler arasında manuel olarak gerçekleştirildiğinde hata yapma ihtimali artar. Manuel deployment süreçleri tekrar üretilebilir değildir, zaman kaybına neden olur ve sistem güvenilirliğini azaltır.

CloudForge bu problemi, uygulama teslim sürecini merkezi ve otomatik bir platform üzerinden yöneterek çözmeyi amaçlar.

## Temel problem cümlesi

GitHub üzerinde geliştirilen container tabanlı uygulamaların AWS ortamına güvenli, tekrar üretilebilir, izlenebilir ve hataya dayanıklı biçimde dağıtılmasını sağlayan bütünleşik bir self-service platforma ihtiyaç vardır.

## Alt problemler

1. Altyapının manuel oluşturulması
2. Test ve deployment süreçlerinin birbirinden kopuk olması
3. Deployment durumunun merkezi olarak izlenememesi
4. Hatalı sürümlerin kullanıcı trafiğini etkilemesi
5. Uygulama ve altyapı metriklerinin dağınık olması
6. Secret bilgilerinin güvenli yönetilememesi
7. Deployment işlemlerinin standartlaştırılamaması
8. Ölçeklendirme kararlarının manuel verilmesi

## Önerilen çözüm

CloudForge aşağıdaki yetenekleri tek platformda birleştirecektir:

- Infrastructure as Code
- Continuous Integration
- Continuous Deployment
- Container orchestration
- Monitoring ve logging
- Security scanning
- Blue-green deployment
- Automated rollback
- Auto Scaling
