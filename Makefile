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
