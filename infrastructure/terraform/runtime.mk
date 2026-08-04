.PHONY: demo-push demo-url demo-health demo-verify demo-ecs-events

demo-push:
	./scripts/push-demo-image.sh

demo-url:
	@terraform -chdir=environments/development output -raw demo_application_url
	@echo

demo-health:
	@URL="$$(terraform -chdir=environments/development output -raw demo_application_url)"; \
	curl --fail --silent "$$URL/actuator/health"; echo

demo-verify:
	./scripts/verify-aws-demo.sh

demo-ecs-events:
	@CLUSTER="$$(terraform -chdir=environments/development output -raw demo_ecs_cluster_name)"; \
	SERVICE="$$(terraform -chdir=environments/development output -raw demo_ecs_service_name)"; \
	aws ecs describe-services \
	  --cluster "$$CLUSTER" \
	  --services "$$SERVICE" \
	  --query "services[0].events[0:10].[createdAt,message]" \
	  --output table
