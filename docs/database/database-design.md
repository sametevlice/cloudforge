# Database Design

## İlgili görev

**CF-009 — Design database ER diagram**

CloudForge platform veritabanı ile deploy edilen demo uygulamasının veritabanı birbirinden ayrıdır.

## CloudForge platform modeli

```mermaid
erDiagram
    USERS ||--o{ APPLICATIONS : owns
    APPLICATIONS ||--o{ DEPLOYMENTS : has
    DEPLOYMENTS ||--o{ DEPLOYMENT_LOGS : produces
    APPLICATIONS ||--o{ APPLICATION_SECRETS : references
    APPLICATIONS ||--o{ ALERTS : generates
    USERS ||--o{ AUDIT_LOGS : performs

    USERS {
        uuid id PK
        string name
        string email UK
        string password_hash
        string role
        timestamp created_at
    }

    APPLICATIONS {
        uuid id PK
        uuid user_id FK
        string name
        string slug
        string repository_url
        string branch
        int port
        string health_path
        string metrics_path
        string status
        timestamp created_at
    }

    DEPLOYMENTS {
        uuid id PK
        uuid application_id FK
        string environment
        string commit_sha
        string image_tag
        string image_digest
        string previous_image_tag
        string status
        string strategy
        timestamp started_at
        timestamp completed_at
        string failure_reason
    }

    DEPLOYMENT_LOGS {
        bigint id PK
        uuid deployment_id FK
        string stage
        string level
        text message
        timestamp created_at
    }

    APPLICATION_SECRETS {
        uuid id PK
        uuid application_id FK
        string secret_name
        string aws_secret_arn
        timestamp created_at
    }

    ALERTS {
        uuid id PK
        uuid application_id FK
        uuid deployment_id FK
        string type
        string severity
        string status
        text message
        timestamp created_at
        timestamp resolved_at
    }

    AUDIT_LOGS {
        bigint id PK
        uuid user_id FK
        string action
        string resource_type
        uuid resource_id
        timestamp created_at
    }
```

## Demo application modeli

İlk kodlayacağımız demo uygulama yalnızca `todos` tablosunu kullanır:

```mermaid
erDiagram
    TODOS {
        uuid id PK
        string title
        text description
        string status
        timestamp created_at
        timestamp updated_at
    }
```

Platform veritabanında gerçek secret değeri tutulmaz. Yalnızca AWS Secrets Manager ARN bilgisi saklanır.
