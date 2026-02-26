# =============================================================================
# Dotfiles — Makefile
# =============================================================================

DOTFILES_DIR := $(shell pwd)
CONFIG_DIR   := $(DOTFILES_DIR)/configs
SHELL        := /bin/bash

.PHONY: help install install-full install-overlay install-minimal uninstall \
        lint test backup restore update stow-% unstow-%

# ─── Default ──────────────────────────────────────────────────────────────

help: ## Show this help
	@echo ""
	@echo "  Dotfiles — available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

# ─── Installation ────────────────────────────────────────────────────────

install: ## Auto-detect platform and install (interactive)
	@bash install.sh

install-full: ## Full installation (all tools + configs)
	@bash install.sh full

install-overlay: ## Overlay mode (for Omarchy / existing setups)
	@bash install.sh overlay

install-minimal: ## Minimal mode (only missing tools)
	@bash install.sh minimal

install-dry: ## Dry-run — preview what would be installed
	@bash install.sh --dry-run full

install-yes: ## Non-interactive full install (accept all defaults)
	@bash install.sh --yes full

# ─── Uninstall ────────────────────────────────────────────────────────────

uninstall: ## Remove all stowed dotfiles symlinks
	@bash install.sh uninstall

# ─── Individual stow operations ──────────────────────────────────────────

stow-%: ## Stow a single config (e.g., make stow-neovim)
	@cd $(CONFIG_DIR) && stow -t ~ --adopt $* && git checkout -- $*
	@echo "✓ Stowed: $*"

unstow-%: ## Unstow a single config (e.g., make unstow-neovim)
	@cd $(CONFIG_DIR) && stow -t ~ -D $*
	@echo "✓ Unstowed: $*"

restow-%: ## Re-stow a single config (unstow + stow)
	@cd $(CONFIG_DIR) && stow -t ~ -R --adopt $* && git checkout -- $*
	@echo "✓ Re-stowed: $*"

# ─── Maintenance ──────────────────────────────────────────────────────────

lint: ## Run shellcheck on all shell scripts
	@echo "Running shellcheck..."
	@find . -name '*.sh' -not -path './configs/zsh/.zsh/*' -not -path './configs/tools/.tools/*' \
		| xargs shellcheck --severity=warning || true
	@echo "✓ Lint complete"

update: ## Pull latest changes and re-stow configs
	@git pull --rebase
	@bash install.sh --yes full
	@echo "✓ Updated"

backup: ## List available config backups
	@bash -c 'source lib/stow.sh; list_backups'

restore: ## Restore a config backup (interactive)
	@bash -c 'source lib/stow.sh; list_backups; \
		read -rp "Enter timestamp to restore: " ts; \
		restore_backup "$$ts"'

# ─── Release ──────────────────────────────────────────────────────────────

version: ## Show current version (latest tag)
	@git describe --tags --abbrev=0 2>/dev/null || echo "no releases yet"

changelog: ## Show changes since last release
	@TAG=$$(git describe --tags --abbrev=0 2>/dev/null); \
	if [ -n "$$TAG" ]; then \
		echo "Changes since $$TAG:"; echo ""; \
		git log "$$TAG..HEAD" --oneline --no-merges; \
	else \
		echo "No releases yet. All commits:"; echo ""; \
		git log --oneline --no-merges -20; \
	fi

# ─── Info ─────────────────────────────────────────────────────────────────

doctor: ## Check system for required tools and health
	@bash $(DOTFILES_DIR)/scripts/doctor.sh $(CONFIG_DIR)
