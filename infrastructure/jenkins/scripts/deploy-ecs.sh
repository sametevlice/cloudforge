#!/usr/bin/env bash

set -Eeuo pipefail

AWS_REGION="${AWS_REGION:-eu-central-1}"

CLUSTER_NAME="${CLUSTER_NAME:-cloudforge-development-cluster}"
SERVICE_NAME="${SERVICE_NAME:-cloudforge-development-demo-app}"
CONTAINER_NAME="${CONTAINER_NAME:-demo-app}"
ECR_REPOSITORY="${ECR_REPOSITORY:-cloudforge-demo-app}"
ALB_NAME="${ALB_NAME:-cloudforge-development-demo-alb}"

IMAGE_TAG="${1:-}"

if [[ -z "${IMAGE_TAG}" ]]; then
  echo "HATA: Image tag verilmedi."
  echo
  echo "Kullanım:"
  echo "./deploy-ecs.sh <git-commit-sha>"
  exit 1
fi

echo "========================================"
echo "CloudForge ECS Deployment"
echo "========================================"
echo
echo "AWS Region : ${AWS_REGION}"
echo "Cluster    : ${CLUSTER_NAME}"
echo "Service    : ${SERVICE_NAME}"
echo "Image tag  : ${IMAGE_TAG}"
echo

echo "==> AWS kimliği kontrol ediliyor"

aws sts get-caller-identity >/dev/null

echo "AWS bağlantısı başarılı."
echo

echo "==> ECR repository bulunuyor"

ECR_URL="$(
  aws ecr describe-repositories \
    --repository-names "${ECR_REPOSITORY}" \
    --region "${AWS_REGION}" \
    --query 'repositories[0].repositoryUri' \
    --output text
)"

IMAGE_URI="${ECR_URL}:${IMAGE_TAG}"

echo "Image:"
echo "${IMAGE_URI}"
echo

echo "==> ECR image kontrol ediliyor"

aws ecr describe-images \
  --repository-name "${ECR_REPOSITORY}" \
  --region "${AWS_REGION}" \
  --image-ids imageTag="${IMAGE_TAG}" \
  >/dev/null

echo "ECR image bulundu."
echo

echo "==> Mevcut ECS deployment bilgisi alınıyor"

CURRENT_TASK_DEFINITION="$(
  aws ecs describe-services \
    --cluster "${CLUSTER_NAME}" \
    --services "${SERVICE_NAME}" \
    --region "${AWS_REGION}" \
    --query 'services[0].taskDefinition' \
    --output text
)"

if [[ -z "${CURRENT_TASK_DEFINITION}" || "${CURRENT_TASK_DEFINITION}" == "None" ]]; then
  echo "HATA: ECS service veya task definition bulunamadı."
  exit 1
fi

echo "Mevcut Task Definition:"
echo "${CURRENT_TASK_DEFINITION}"
echo

WORK_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${WORK_DIR}"
}

trap cleanup EXIT

CURRENT_JSON="${WORK_DIR}/current-task-definition.json"
NEW_JSON="${WORK_DIR}/new-task-definition.json"

echo "==> Task Definition indiriliyor"

aws ecs describe-task-definition \
  --task-definition "${CURRENT_TASK_DEFINITION}" \
  --region "${AWS_REGION}" \
  --query 'taskDefinition' \
  > "${CURRENT_JSON}"

echo "==> Yeni Task Definition hazırlanıyor"

jq \
  --arg IMAGE_URI "${IMAGE_URI}" \
  --arg IMAGE_TAG "${IMAGE_TAG}" \
  --arg CONTAINER_NAME "${CONTAINER_NAME}" \
  '
  del(
    .taskDefinitionArn,
    .revision,
    .status,
    .requiresAttributes,
    .compatibilities,
    .registeredAt,
    .registeredBy
  )
  |
  .containerDefinitions |= map(
    if .name == $CONTAINER_NAME then
      .image = $IMAGE_URI
      |
      .environment = (
        (.environment // [])
        |
        map(
          select(
            .name != "APP_VERSION"
            and
            .name != "GIT_COMMIT"
          )
        )
        +
        [
          {
            "name": "APP_VERSION",
            "value": $IMAGE_TAG
          },
          {
            "name": "GIT_COMMIT",
            "value": $IMAGE_TAG
          }
        ]
      )
    else
      .
    end
  )
  ' \
  "${CURRENT_JSON}" \
  > "${NEW_JSON}"

echo "==> Yeni ECS Task Definition revision oluşturuluyor"

NEW_TASK_DEFINITION="$(
  aws ecs register-task-definition \
    --cli-input-json "file://${NEW_JSON}" \
    --region "${AWS_REGION}" \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text
)"

echo "Yeni Task Definition:"
echo "${NEW_TASK_DEFINITION}"
echo

rollback() {
  echo
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "DEPLOYMENT BAŞARISIZ - ROLLBACK"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo
  echo "Eski Task Definition:"
  echo "${CURRENT_TASK_DEFINITION}"
  echo

  aws ecs update-service \
    --cluster "${CLUSTER_NAME}" \
    --service "${SERVICE_NAME}" \
    --task-definition "${CURRENT_TASK_DEFINITION}" \
    --region "${AWS_REGION}" \
    >/dev/null

  echo "Rollback deployment başlatıldı."
  echo

  aws ecs wait services-stable \
    --cluster "${CLUSTER_NAME}" \
    --services "${SERVICE_NAME}" \
    --region "${AWS_REGION}"

  echo "Rollback tamamlandı."
}

echo "==> ECS Service güncelleniyor"

aws ecs update-service \
  --cluster "${CLUSTER_NAME}" \
  --service "${SERVICE_NAME}" \
  --task-definition "${NEW_TASK_DEFINITION}" \
  --region "${AWS_REGION}" \
  >/dev/null

echo "Deployment başladı."
echo

echo "==> ECS Service stable olması bekleniyor"

if ! aws ecs wait services-stable \
  --cluster "${CLUSTER_NAME}" \
  --services "${SERVICE_NAME}" \
  --region "${AWS_REGION}"
then
  echo "ECS service stable duruma ulaşamadı."
  rollback
  exit 1
fi

echo "ECS Service stable."
echo

echo "==> Application Load Balancer adresi alınıyor"

ALB_DNS="$(
  aws elbv2 describe-load-balancers \
    --names "${ALB_NAME}" \
    --region "${AWS_REGION}" \
    --query 'LoadBalancers[0].DNSName' \
    --output text
)"

APPLICATION_URL="http://${ALB_DNS}"

echo "Application URL:"
echo "${APPLICATION_URL}"
echo

echo "==> Application health check"

if ! curl \
  --fail \
  --silent \
  --show-error \
  "${APPLICATION_URL}/actuator/health"
then
  echo
  echo "Application health check başarısız."
  rollback
  exit 1
fi

echo
echo "Application health check başarılı."
echo

echo "==> Deploy edilen version kontrol ediliyor"

VERSION_RESPONSE="$(
  curl \
    --fail \
    --silent \
    "${APPLICATION_URL}/api/version"
)"

echo "${VERSION_RESPONSE}"
echo

if ! echo "${VERSION_RESPONSE}" \
  | jq -e \
      --arg IMAGE_TAG "${IMAGE_TAG}" \
      '
      .version == $IMAGE_TAG
      or
      .commit == $IMAGE_TAG
      ' \
  >/dev/null
then
  echo "Beklenen image tag çalışmıyor."
  rollback
  exit 1
fi

echo
echo "========================================"
echo "DEPLOYMENT BAŞARILI"
echo "========================================"
echo
echo "Image:"
echo "${IMAGE_URI}"
echo
echo "Task Definition:"
echo "${NEW_TASK_DEFINITION}"
echo
echo "Application:"
echo "${APPLICATION_URL}"
