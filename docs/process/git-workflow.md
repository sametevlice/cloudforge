# Git Workflow

## İlgili görev

**CF-010 — Define Git branching strategy**

## Branch yapısı

```text
main
├── develop
├── feature/*
├── fix/*
├── docs/*
├── infra/*
└── ci/*
```

## Kurallar

- `main`: Her zaman yayınlanabilir durumda olmalıdır.
- `develop`: Tamamlanan özelliklerin birleştiği geliştirme branch'idir.
- Yeni işler ayrı branch üzerinde yapılır.
- `main` branch'e doğrudan push yapılmaz.
- Her değişiklik pull request ile birleştirilir.
- Testler geçmeden PR merge edilmez.
- Bir branch mümkün olduğunca tek issue çözmelidir.

## İsim örnekleri

```text
feature/todo-api
feature/version-endpoint
fix/database-connection
docs/aws-network
infra/vpc-module
ci/demo-app-tests
```

## Commit standardı

```text
feat: yeni özellik
fix: hata düzeltmesi
docs: dokümantasyon
test: test değişikliği
ci: pipeline değişikliği
infra: Terraform veya AWS
build: build sistemi
refactor: davranışı değiştirmeyen düzenleme
chore: bakım
```

## Pull request kontrolü

- [ ] Issue bağlantısı eklendi.
- [ ] Testler çalışıyor.
- [ ] README gerekiyorsa güncellendi.
- [ ] Secret veya erişim anahtarı eklenmedi.
- [ ] Hata ve çözüm notu gerekiyorsa kaydedildi.
- [ ] Ekran görüntüsü gerekiyorsa alındı.
