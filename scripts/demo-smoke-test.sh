#!/usr/bin/env bash
set -Eeuo pipefail

BASE_URL="${BASE_URL:-http://localhost:8080}"

step() { printf "\n==> %s\n" "$1"; }

command -v curl >/dev/null || { echo "curl bulunamadı"; exit 1; }
command -v python3 >/dev/null || { echo "python3 bulunamadı"; exit 1; }

step "Health kontrolü"
health="$(curl --fail --silent "${BASE_URL}/actuator/health")"
python3 -c 'import json,sys; p=json.load(sys.stdin); assert p["status"]=="UP"; print("Health:",p["status"])' <<<"${health}"

step "Version kontrolü"
version="$(curl --fail --silent "${BASE_URL}/api/version")"
python3 -c 'import json,sys; p=json.load(sys.stdin); assert p["application"]=="cloudforge-demo-app"; print(p)' <<<"${version}"

step "Todo oluşturma"
created="$(curl --fail --silent -X POST "${BASE_URL}/api/todos" \
  -H "Content-Type: application/json" \
  -d '{"title":"CloudForge smoke test","description":"API ve metric doğrulaması"}')"
todo_id="$(python3 -c 'import json,sys; p=json.load(sys.stdin); assert p["status"]=="PENDING"; print(p["id"])' <<<"${created}")"
echo "Todo ID: ${todo_id}"

step "Todo tamamlama"
updated="$(curl --fail --silent -X PUT "${BASE_URL}/api/todos/${todo_id}" \
  -H "Content-Type: application/json" \
  -d '{"title":"CloudForge smoke test","description":"Tamamlandı","status":"COMPLETED"}')"
python3 -c 'import json,sys; p=json.load(sys.stdin); assert p["status"]=="COMPLETED"; print("Status:",p["status"])' <<<"${updated}"

step "Custom metric kontrolü"
metrics="$(curl --fail --silent "${BASE_URL}/actuator/prometheus")"
grep -q 'cloudforge_todo_operations_total' <<<"${metrics}"
grep -q 'operation="create"' <<<"${metrics}"
grep -q 'operation="complete"' <<<"${metrics}"
echo "Custom metrikler bulundu."

step "Test kaydını silme"
curl --fail --silent -X DELETE "${BASE_URL}/api/todos/${todo_id}" >/dev/null

echo
echo "Smoke test başarıyla tamamlandı."
