.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Start services in detached detached
	docker compose up -d

ps: ## List running containers
	docker compose ps

down: ## Stop and remove containers
	docker compose down

logs: ## Tail logs for a given container. Usage: make logs container=kali
	docker compose logs -f $(container)

access: ## Access the Bash shell of a running container. Usage: make access container=kali
	docker exec -it $(container) /bin/bash