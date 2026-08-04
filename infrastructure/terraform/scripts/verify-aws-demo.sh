#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEV_DIR="$(cd "${SCRIPT_DIR}/../environments/development" && pwd)"

URL="$(terraform -chdir="${DEV_DIR}" output -raw demo_application_url)"

echo "URL: ${URL}"

echo "==> Health"
curl --fail --silent "${URL}/actuator/health"
echo

echo "==> Version"
curl --fail --silent "${URL}/api/version"
echo

echo "==> Create Todo"
CREATED="$(curl --fail --silent -X POST "${URL}/api/todos" \
  -H "Content-Type: application/json" \
  -d '{"title":"First AWS deployment","description":"ECS Fargate verification"}')"
echo "${CREATED}"

TODO_ID="$(python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])' <<<"${CREATED}")"

echo "==> Delete Todo"
curl --fail --silent -X DELETE "${URL}/api/todos/${TODO_ID}" >/dev/null

echo "AWS demo verification başarılı."
