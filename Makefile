.DEFAULT_GOAL := help

.PHONY: help
help: ## Show all available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: reload
reload: ## Rebuild MBP M1 configuration
	nix run nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch --flake .#CPH-NJ50WV17R
.PHONY: update
update: ## Update nixpkgs inputs
	nix flake update
