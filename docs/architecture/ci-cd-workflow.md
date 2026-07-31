# CI/CD Workflow

## İlgili görev

**CF-008 — Create CI/CD workflow diagram**

## Sorumluluk ayrımı

| Araç | Sorumluluk |
|---|---|
| GitHub Actions | Test, build, Docker image üretimi, güvenlik taraması ve ECR push |
| Jenkins | Staging deployment, doğrulama, production deployment ve rollback |
| CloudForge Backend | Deployment kaydı, pipeline tetikleme ve durum takibi |
| Prometheus | Production doğrulama metrikleri |
| Amazon ECR | Değiştirilemez deployment artifact'larını saklama |

## Ana akış

```mermaid
flowchart LR
    A[Developer Push] --> B[GitHub Actions]
    B --> C{Tests Passed?}
    C -- No --> X[Stop Pipeline]
    C -- Yes --> D[Docker Build]
    D --> E[Trivy Scan]
    E --> F{Critical Vulnerability?}
    F -- Yes --> X
    F -- No --> G[Push Image to ECR]
    G --> H[Notify CloudForge]
    H --> I[Jenkins Staging Deployment]
    I --> J{Health and Smoke Tests}
    J -- Fail --> Y[Mark Deployment Failed]
    J -- Pass --> K[Production Approval]
    K --> L[Blue-Green Deployment]
    L --> M[Prometheus Verification]
    M --> N{Metrics Healthy?}
    N -- Yes --> O[Deployment Successful]
    N -- No --> P[Automatic Rollback]
```

## Branch davranışı

| Branch | Çalışacak işlemler |
|---|---|
| `feature/*` | Test ve kod kalite kontrolü |
| `develop` | Test, Docker build ve staging adayı |
| `main` | Test, scan, ECR push ve production adayı |

## Pipeline engelleme kuralları

Deployment aşağıdaki durumlarda devam etmez:

- Unit veya integration test başarısızsa
- Docker image oluşturulamıyorsa
- Kritik güvenlik açığı bulunursa
- `.cloudforge.yml` geçersizse
- Image ECR'a gönderilemezse
- Staging health check başarısızsa

## Image sürümleme

Her image en az commit SHA ile etiketlenir:

```text
cloudforge-demo-app:a84f92d
```

Production deployment kaydı ayrıca image digest ve ECS task definition revision bilgisini saklar.
