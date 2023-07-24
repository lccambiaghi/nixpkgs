.DEFAULT_GOAL := help

.PHONY: help
help: ## Show all available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: reload
reload: ## Rebuild MBP M1 configuration
	darwin-rebuild switch --flake .#macbookpro-m1

.PHONY: update
update: ## Update nixpkgs inputs
	nix flake update
