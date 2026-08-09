SHELL := /bin/bash

.PHONY: help build up down restart logs password ps aws-check shell

help:
	@echo "CloudForge Jenkins commands"
	@echo ""
	@echo "  make build      Jenkins Docker image oluştur"
	@echo "  make up         Jenkins başlat"
	@echo "  make down       Jenkins durdur"
	@echo "  make restart    Jenkins yeniden başlat"
	@echo "  make logs       Jenkins loglarını takip et"
	@echo "  make password   İlk admin şifresini göster"
	@echo "  make ps         Jenkins container durumunu göster"
	@echo "  make aws-check  Jenkins içinden AWS bağlantısını doğrula"
	@echo "  make shell      Jenkins container shell aç"

build:
	docker compose build

up:
	docker compose up -d --build

down:
	docker compose down

restart:
	docker compose restart jenkins

logs:
	docker compose logs -f jenkins

password:
	docker compose exec jenkins \
		cat /var/jenkins_home/secrets/initialAdminPassword

ps:
	docker compose ps

aws-check:
	docker compose exec jenkins \
		aws sts get-caller-identity --no-cli-pager

shell:
	docker compose exec jenkins bash
