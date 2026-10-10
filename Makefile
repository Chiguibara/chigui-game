export UID := $(shell id -u)
export GID := $(shell id -g)
export WEB_PORT ?= 8080

RUN := docker compose run --rm flutter
FLUTTER := $(RUN) flutter

.DEFAULT_GOAL := help
.PHONY: help image shell deps l10n sounds icons web build-web build-site apk test analyze format clean

help: ## Show available targets
	@grep -E '^[a-z0-9-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-10s %s\n", $$1, $$2}'

image: ## Build the Flutter Docker image
	docker compose build

shell: ## Open a shell in the Flutter container
	$(RUN) bash

deps: ## Fetch Dart/Flutter packages
	$(FLUTTER) pub get

l10n: ## Regenerate localization code from lib/l10n/*.arb
	$(FLUTTER) gen-l10n

sounds: ## Regenerate the synthesized sound effects in assets/sounds
	$(RUN) python3 tools/make_sounds.py

icons: ## Regenerate the app icons (Android, web, Play) from the code-drawn Chigüi
	$(FLUTTER) test tools/icon/make_icons_test.dart

web: ## Run with hot reload at http://localhost:8080 (WEB_PORT=… to change; r = reload, q = quit)
	docker compose run --rm --service-ports flutter \
		flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

build-web: ## Build the release web version into build/web
	$(FLUTTER) build web --release

build-site: ## Production build for juego.chiguibara.es (no Google CDN) into build/web
	$(FLUTTER) build web --release --no-web-resources-cdn
	find build/web -name '*.symbols' -delete

apk: ## Android test APK (all CPUs, debug-signed) into build/app/outputs/flutter-apk
	$(FLUTTER) build apk --release

test: l10n ## Run all tests
	$(FLUTTER) test

analyze: l10n ## Run static analysis
	$(FLUTTER) analyze

format: ## Format Dart code
	$(RUN) dart format lib test

clean: ## Remove build outputs
	$(FLUTTER) clean
