#!/usr/bin/env bash

set -euo pipefail

API_URL="${CLOUDFORGE_API_URL:-http://localhost:8090/api}"
HEALTH_URL="${CLOUDFORGE_HEALTH_URL:-http://localhost:8090/actuator/health}"

echo
echo "CloudForge Platform Smoke Test"
echo "=============================="
echo

command -v curl >/dev/null || {
  echo "❌ curl is required"
  exit 1
}

command -v jq >/dev/null || {
  echo "❌ jq is required"
  exit 1
}

echo "1. Waiting for backend health..."

STATUS=""

for attempt in $(seq 1 30); do

  echo "   health attempt ${attempt}/30..."

  if HEALTH_RESPONSE="$(
    curl \
      --fail \
      --silent \
      --show-error \
      "$HEALTH_URL" \
      2>/dev/null
  )"
  then

    STATUS="$(
      echo "$HEALTH_RESPONSE" \
        | jq -r '.status'
    )"

    if [ "$STATUS" = "UP" ]; then
      echo "✅ Backend healthy"
      break
    fi
  fi

  sleep 2
done


if [ "$STATUS" != "UP" ]; then
  echo "❌ Backend did not become healthy in time."
  echo
  echo "Backend logs:"
  docker logs \
    cloudforge-platform-backend \
    --tail 100 \
    2>/dev/null || true

  exit 1
fi

UNIQUE_ID="$(date +%s)"

APP_NAME="smoke-app-${UNIQUE_ID}"
REPOSITORY_URL="https://github.com/cloudforge-smoke/${APP_NAME}"

echo
echo "2. Creating application..."

APPLICATION_RESPONSE="$(
  curl -fsS \
    -X POST \
    "${API_URL}/applications" \
    -H "Content-Type: application/json" \
    -d "{
      \"name\": \"${APP_NAME}\",
      \"repositoryUrl\": \"${REPOSITORY_URL}\",
      \"defaultBranch\": \"main\"
    }"
)"

APP_ID="$(
  echo "$APPLICATION_RESPONSE" \
    | jq -r '.id'
)"

if [ -z "$APP_ID" ] || [ "$APP_ID" = "null" ]; then
  echo "❌ Application creation failed"
  echo "$APPLICATION_RESPONSE"
  exit 1
fi

echo "✅ Application created: $APP_ID"


echo
echo "3. Creating deployment..."

DEPLOYMENT_RESPONSE="$(
  curl -fsS \
    -X POST \
    "${API_URL}/applications/${APP_ID}/deployments" \
    -H "Content-Type: application/json" \
    -d '{
      "environment": "DEVELOPMENT",
      "imageTag": "smoke-test-image"
    }'
)"

DEPLOYMENT_ID="$(
  echo "$DEPLOYMENT_RESPONSE" \
    | jq -r '.id'
)"

if [ -z "$DEPLOYMENT_ID" ] \
  || [ "$DEPLOYMENT_ID" = "null" ]; then

  echo "❌ Deployment creation failed"
  echo "$DEPLOYMENT_RESPONSE"
  exit 1
fi

echo "✅ Deployment created: $DEPLOYMENT_ID"


echo
echo "4. Waiting for deployment..."

FINAL_STATUS=""

for attempt in $(seq 1 15); do

  DEPLOYMENT="$(
    curl -fsS \
      "${API_URL}/deployments/${DEPLOYMENT_ID}"
  )"

  FINAL_STATUS="$(
    echo "$DEPLOYMENT" \
      | jq -r '.status'
  )"

  echo "   attempt ${attempt}: ${FINAL_STATUS}"

  case "$FINAL_STATUS" in

    SUCCEEDED)
      break
      ;;

    FAILED|ROLLED_BACK)
      echo "❌ Deployment ended with ${FINAL_STATUS}"
      echo "$DEPLOYMENT" | jq
      exit 1
      ;;

  esac

  sleep 1

done


if [ "$FINAL_STATUS" != "SUCCEEDED" ]; then
  echo "❌ Deployment did not succeed"
  exit 1
fi

echo "✅ Deployment succeeded"


echo
echo "5. Reading deployment timeline..."

EVENTS="$(
  curl -fsS \
    "${API_URL}/deployments/${DEPLOYMENT_ID}/events"
)"

echo "$EVENTS" | jq


EVENT_COUNT="$(
  echo "$EVENTS" \
    | jq 'length'
)"

if [ "$EVENT_COUNT" -lt 3 ]; then
  echo "❌ Not enough deployment events"
  exit 1
fi

echo
echo "✅ Deployment events recorded"


echo
echo "=============================="
echo "✅ CLOUDFORGE SMOKE TEST PASSED"
echo "=============================="
