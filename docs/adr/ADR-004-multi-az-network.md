# ADR-004: AWS Ağının İki Availability Zone Üzerinde Tasarlanması

## Durum

Kabul edildi.

## Karar

CloudForge VPC tasarımı en az iki Availability Zone içerecektir. Her AZ için public, private application, private data ve management subnetleri oluşturulacaktır.

Production-like profilde her AZ kendi NAT Gateway'ini kullanacaktır.

## Gerekçeler

- ALB iki AZ kullanır.
- ECS servisleri çoklu AZ çalışabilir.
- RDS subnet group Multi-AZ geçişine hazır olur.
- Tek AZ arızasının etkisi azaltılır.

## Olumsuz sonuçlar

- NAT Gateway ve kaynak maliyeti artar.
- Terraform modülü daha karmaşık olur.
