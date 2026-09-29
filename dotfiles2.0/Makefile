OS := $(shell sh ./scripts/detect-os.sh)
PROFILE ?= base
GROUPS ?= core
DRY_RUN ?= 0

.DEFAULT_GOAL := help
.PHONY: help bootstrap packages shell link plugins doctor test all

# Help target shows available make goals and usage examples.
help:
	@echo "Targets:"
	@echo "  make bootstrap            # minimal prerequisites"
	@echo "  make packages PROFILE=...  # install package manifest/groups"
	@echo "  make shell                # install Oh My Zsh when missing"
	@echo "  make link                 # symlink dotfiles"
	@echo "  make plugins              # set up TPM and tmux plugins"
	@echo "  make doctor               # validate repo/scripts/maps"
	@echo "  make test                 # full dry-run smoke test"
	@echo "  make all PROFILE=full     # full setup"
	@echo ""
	@echo "Examples:"
	@echo "  make all PROFILE=base"
	@echo "  make packages GROUPS='core dev gui'"
	@echo "  make all DRY_RUN=1        # preview without changes"

# Prepare minimal environment (create common directories, etc).
bootstrap:
	DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./bootstrap/common.sh

# Install package groups according to the detected OS.
packages:
	@if [ "$(OS)" = "macos" ]; then sh ./scripts/banners/packages.sh; fi
	@if [ ! -f "./bootstrap/$(OS).sh" ]; then \
		echo "Unsupported OS '$(OS)' (missing ./bootstrap/$(OS).sh)" >&2; \
		exit 1; \
	fi
	OS=$(OS) PROFILE=$(PROFILE) GROUPS="$(GROUPS)" DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./bootstrap/$(OS).sh

# Install shell prerequisites used by the current Mac Zsh configuration.
shell:
	@if [ "$(OS)" = "macos" ]; then sh ./scripts/banners/shell.sh; DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./scripts/setup-zsh.sh; \
	else echo "Oh My Zsh setup is currently Mac-only"; fi

# Create backups and symlinks via stow.
link:
	@if [ "$(OS)" = "macos" ]; then sh ./scripts/banners/links.sh; fi
	DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./scripts/backup.sh
	DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./scripts/link.sh

# Install TPM and the plugins declared by the linked tmux config.
plugins:
	@if [ "$(OS)" = "macos" ]; then sh ./scripts/banners/plugins.sh; DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./scripts/tmux-plugins.sh; \
	else echo "TPM setup is currently Mac-only"; fi

# Validate syntax and configuration sanity.
doctor:
	sh ./scripts/doctor.sh

# Full non-destructive test run (no package/filesystem changes).
test: doctor
	sh ./tests/run-wrapper.sh
	sh ./tests/backup-symlink.sh
	sh ./tests/dry-run-no-change.sh

# Perform the full installation (bootstrap → packages → shell → link → plugins).
all: bootstrap packages shell link plugins
