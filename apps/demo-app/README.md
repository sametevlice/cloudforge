# CloudForge Demo Application

CloudForge platformu üzerinden deploy edilecek ilk örnek uygulamadır. Java 21, Spring Boot, PostgreSQL, Flyway, Docker, Actuator ve Prometheus metriklerini kullanır.

## Technology Stack

- Java 21
- Spring Boot 3.5.16
- Spring Web
- Spring Data JPA
- PostgreSQL
- Flyway
- Spring Boot Actuator
- Micrometer Prometheus
- JUnit, Mockito ve Testcontainers
- Docker ve Docker Compose

## API Endpoints

| Method | Endpoint | Açıklama |
|---|---|---|
| GET | `/api/todos` | Tüm görevleri getirir |
| GET | `/api/todos/{id}` | Tek görevi getirir |
| POST | `/api/todos` | Yeni görev oluşturur |
| PUT | `/api/todos/{id}` | Görevi günceller |
| DELETE | `/api/todos/{id}` | Görevi siler |
| GET | `/api/version` | Çalışan image sürümünü ve commit bilgisini gösterir |
| GET | `/actuator/health` | Health check |
| GET | `/actuator/prometheus` | Prometheus metrics |

## Local Run

Önce PostgreSQL'i başlat:

```bash
docker compose up -d postgres
```

Uygulamayı çalıştır:

```bash
mvn spring-boot:run
```

Alternatif olarak bütün stack'i Docker ile başlat:

```bash
docker compose up --build
```

## Test

```bash
mvn clean verify
```

Docker çalışıyorsa PostgreSQL Testcontainers integration testi de çalışır.

## Example Requests

Yeni görev oluştur:

```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Docker image oluştur",
    "description": "Multi-stage Dockerfile kullan"
  }'
```

Görevleri listele:

```bash
curl http://localhost:8080/api/todos
```

Version kontrolü:

```bash
curl http://localhost:8080/api/version
```

Health kontrolü:

```bash
curl http://localhost:8080/actuator/health
```

Prometheus metriği:

```bash
curl http://localhost:8080/actuator/prometheus
```

## Project Contract

Repository aşağıdaki CloudForge sözleşmesini sağlar:

- `Dockerfile`
- `.cloudforge.yml`
- `/actuator/health`
- `/actuator/prometheus`
- `/api/version`
- Commit SHA ile image sürümleme desteği
