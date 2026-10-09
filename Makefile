export UID := $(shell id -u)
export GID := $(shell id -g)
export WEB_PORT ?= 8080

RUN := docker compose run --rm flutter
FLUTTER := $(RUN) flutter

.DEFAULT_GOAL := help
.PHONY: help image shell deps web build-web test analyze format clean

help: ## Show available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-10s %s\n", $$1, $$2}'

image: ## Build the Flutter Docker image
	docker compose build

shell: ## Open a shell in the Flutter container
	$(RUN) bash

deps: ## Fetch Dart/Flutter packages
	$(FLUTTER) pub get

web: ## Run the game with hot reload at http://localhost:$(WEB_PORT) (r = reload, q = quit)
	docker compose run --rm --service-ports flutter \
		flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

build-web: ## Build the release web version into build/web
	$(FLUTTER) build web --release

test: ## Run all tests
	$(FLUTTER) test

analyze: ## Run static analysis
	$(FLUTTER) analyze

format: ## Format Dart code
	$(RUN) dart format lib test

clean: ## Remove build outputs
	$(FLUTTER) clean
