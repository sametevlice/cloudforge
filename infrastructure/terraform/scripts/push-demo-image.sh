#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${TF_ROOT}/../.." && pwd)"
DEV_DIR="${TF_ROOT}/environments/development"

AWS_REGION="${AWS_REGION:-eu-central-1}"
IMAGE_TAG="${IMAGE_TAG:-$(git -C "${REPO_ROOT}" rev-parse --short=12 HEAD)}"

ECR_URL="$(terraform -chdir="${DEV_DIR}" output -raw demo_ecr_repository_url)"
REGISTRY="${ECR_URL%%/*}"

echo "ECR: ${ECR_URL}"
echo "Tag: ${IMAGE_TAG}"

aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${REGISTRY}"

docker build \
  --platform linux/amd64 \
  --tag "${ECR_URL}:${IMAGE_TAG}" \
  "${REPO_ROOT}/apps/demo-app"

docker push "${ECR_URL}:${IMAGE_TAG}"

cat > "${DEV_DIR}/runtime.auto.tfvars" <<EOF
enable_runtime_foundation = true
deploy_demo_service       = true
demo_image_tag            = "${IMAGE_TAG}"
EOF

echo
echo "Image push tamamlandı."
echo "runtime.auto.tfvars oluşturuldu."
echo "Sonraki adım: make -C infrastructure/terraform dev-plan"
