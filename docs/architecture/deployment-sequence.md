# Deployment Sequence

![CloudForge deployment akışı](diagrams/deployment-flow.svg)

```mermaid
sequenceDiagram
    actor Developer
    participant GitHub
    participant GHA as GitHub Actions
    participant ECR as Amazon ECR
    participant CF as CloudForge API
    participant Jenkins
    participant ECS as Amazon ECS
    participant ALB
    participant Prom as Prometheus

    Developer->>GitHub: Push commit
    GitHub->>GHA: Start CI
    GHA->>GHA: Test, build and scan
    GHA->>ECR: Push image with commit SHA
    GHA->>CF: Report successful build
    CF->>Jenkins: Start deployment
    Jenkins->>ECS: Deploy image to staging
    Jenkins->>ECS: Run health and smoke checks
    alt Staging successful
        Jenkins->>ECS: Create green production revision
        ECS->>ALB: Register healthy green targets
        Jenkins->>ALB: Switch production traffic
        Jenkins->>Prom: Query deployment metrics
        alt Metrics healthy
            Jenkins->>CF: Mark deployment successful
        else Threshold violated
            Jenkins->>ALB: Restore blue traffic
            Jenkins->>CF: Mark deployment rolled back
        end
    else Staging failed
        Jenkins->>CF: Mark deployment failed
    end
```

## Kritik tasarım kuralları

- CI başarısızsa CD başlamaz.
- Staging doğrulanmadan production deployment yapılmaz.
- Production trafik geçişi health check sonrası yapılır.
- Rollback hedefi image tag yerine mümkün olduğunda image digest ve task definition revision ile tanımlanır.
- Her çağrıda deployment ID taşınır.
