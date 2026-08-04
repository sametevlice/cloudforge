SHELL := /bin/bash

BOOTSTRAP_DIR := bootstrap
DEV_DIR := environments/development
DEV_BACKEND_FILE := $(DEV_DIR)/backend.hcl
DEV_VARS_FILE := $(DEV_DIR)/terraform.tfvars

.PHONY: help preflight fmt fmt-check \
        bootstrap-init bootstrap-validate bootstrap-plan bootstrap-apply bootstrap-output \
        dev-init dev-validate dev-plan dev-apply dev-output dev-destroy clean

help:
	@echo "CloudForge Terraform commands"
	@echo ""
	@echo "  make preflight            Terraform ve AWS bağlantısını kontrol eder"
	@echo "  make fmt                  Tüm Terraform dosyalarını biçimlendirir"
	@echo "  make fmt-check            Biçim kontrolü yapar"
	@echo ""
	@echo "  make bootstrap-init       State bucket yapılandırmasını başlatır"
	@echo "  make bootstrap-plan       State bucket planı üretir"
	@echo "  make bootstrap-apply      State bucket oluşturur"
	@echo "  make bootstrap-output     Bucket adını gösterir"
	@echo ""
	@echo "  make dev-init             Development backend'ini başlatır"
	@echo "  make dev-plan             Development VPC planı üretir"
	@echo "  make dev-apply            Development VPC'yi oluşturur"
	@echo "  make dev-output           Terraform output değerlerini gösterir"
	@echo "  make dev-destroy          Development VPC kaynaklarını siler"

preflight:
	./scripts/preflight.sh

fmt:
	terraform fmt -recursive .

fmt-check:
	terraform fmt -check -recursive .

bootstrap-init:
	terraform -chdir=$(BOOTSTRAP_DIR) init

bootstrap-validate: bootstrap-init
	terraform -chdir=$(BOOTSTRAP_DIR) validate

bootstrap-plan: bootstrap-validate
	@test -f $(BOOTSTRAP_DIR)/terraform.tfvars || \
		(echo "$(BOOTSTRAP_DIR)/terraform.tfvars bulunamadı. terraform.tfvars.example dosyasını kopyala."; exit 1)
	terraform -chdir=$(BOOTSTRAP_DIR) plan -out=bootstrap.tfplan

bootstrap-apply:
	@test -f $(BOOTSTRAP_DIR)/bootstrap.tfplan || \
		(echo "Önce make bootstrap-plan çalıştır."; exit 1)
	terraform -chdir=$(BOOTSTRAP_DIR) apply bootstrap.tfplan

bootstrap-output:
	terraform -chdir=$(BOOTSTRAP_DIR) output

dev-init:
	@test -f $(DEV_BACKEND_FILE) || \
		(echo "$(DEV_BACKEND_FILE) bulunamadı. backend.hcl.example dosyasını kopyala ve bucket adını yaz."; exit 1)
	terraform -chdir=$(DEV_DIR) init -reconfigure -backend-config=backend.hcl

dev-validate: dev-init
	terraform -chdir=$(DEV_DIR) validate

dev-plan: dev-validate
	@test -f $(DEV_VARS_FILE) || \
		(echo "$(DEV_VARS_FILE) bulunamadı. terraform.tfvars.example dosyasını kopyala."; exit 1)
	terraform -chdir=$(DEV_DIR) plan -out=development.tfplan

dev-apply:
	@test -f $(DEV_DIR)/development.tfplan || \
		(echo "Önce make dev-plan çalıştır."; exit 1)
	terraform -chdir=$(DEV_DIR) apply development.tfplan

dev-output:
	terraform -chdir=$(DEV_DIR) output

dev-destroy:
	@test -f $(DEV_VARS_FILE) || \
		(echo "$(DEV_VARS_FILE) bulunamadı."; exit 1)
	terraform -chdir=$(DEV_DIR) destroy

clean:
	find . -type d -name ".terraform" -prune -exec rm -rf {} +
	find . -type f -name "*.tfplan" -delete
-include runtime.mk
