# ADR-005: Ayrı Development ve Production-like Network Profilleri

## Durum

Kabul edildi.

## Karar

Terraform network modülü `cost-saving`, `single-nat` ve `production-like` profillerini destekleyecektir.

Cost-saving profilde ECS task'ları kontrollü biçimde public subnet ve public IP kullanabilir. Security Group yalnızca ALB'den inbound kabul eder. RDS her durumda private kalır.

Final demo ve akademik deneylerde production-like profil kurulacaktır. Günlük geliştirmede cost-saving profil veya local Docker ortamı kullanılacaktır.

## Sonuçlar

- Geliştirme maliyeti kontrol edilir.
- Production mimarisinden vazgeçilmez.
- İki yaklaşım raporda maliyet ve güvenlik açısından karşılaştırılabilir.
