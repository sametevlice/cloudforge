SHELL := /bin/bash
DEMO_DIR := apps/demo-app

.PHONY: help demo-config demo-test demo-build demo-up demo-down demo-reset demo-ps demo-logs demo-smoke

help:
	@echo "make demo-config  - Docker Compose doğrulama"
	@echo "make demo-test    - Maven testleri"
	@echo "make demo-build   - Application image build"
	@echo "make demo-up      - Tüm local stack'i başlat"
	@echo "make demo-down    - Container'ları durdur"
	@echo "make demo-reset   - Container ve volume'ları sil"
	@echo "make demo-ps      - Servis durumları"
	@echo "make demo-logs    - Application logları"
	@echo "make demo-smoke   - Otomatik API smoke test"

demo-config:
	cd $(DEMO_DIR) && docker compose config

demo-test:
	cd $(DEMO_DIR) && mvn clean verify

demo-build:
	cd $(DEMO_DIR) && docker compose build application

demo-up:
	cd $(DEMO_DIR) && docker compose up -d --build

demo-down:
	cd $(DEMO_DIR) && docker compose down

demo-reset:
	cd $(DEMO_DIR) && docker compose down -v

demo-ps:
	cd $(DEMO_DIR) && docker compose ps

demo-logs:
	cd $(DEMO_DIR) && docker compose logs -f application

demo-smoke:
	./scripts/demo-smoke-test.sh

.PHONY: security-tflint security-checkov security-secrets security-iac security-image load-test-local load-test-aws

security-tflint:
	tflint --init
	tflint --recursive --chdir infrastructure/terraform

security-checkov:
	checkov \
		-d infrastructure/terraform \
		--framework terraform \
		--compact

security-secrets:
	trivy fs \
		--scanners secret \
		.

security-iac:
	trivy config \
		--severity HIGH,CRITICAL \
		infrastructure/terraform

security-image:
	trivy image \
		--severity HIGH,CRITICAL \
		--ignore-unfixed \
		cloudforge-demo-app:security-test

load-test-local:
	k6 run \
		-e BASE_URL=http://localhost:8080 \
		tests/performance/demo-api.js

load-test-aws:
	@test -n "$(BASE_URL)" || \
		(echo "Kullanım: make load-test-aws BASE_URL=http://..." && exit 1)

	k6 run \
		-e BASE_URL="$(BASE_URL)" \
		tests/performance/demo-api.js
