OS := $(shell sh ./scripts/detect-os.sh)
PROFILE ?= base
GROUPS ?= core
DRY_RUN ?= 0

.DEFAULT_GOAL := help
.PHONY: help bootstrap packages link doctor test all

# Help target shows available make goals and usage examples.
help:
	@echo "Targets:"
	@echo "  make bootstrap            # minimal prerequisites"
	@echo "  make packages PROFILE=...  # install package groups"
	@echo "  make link                 # symlink dotfiles"
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
	@if [ ! -f "./bootstrap/$(OS).sh" ]; then \
		echo "Unsupported OS '$(OS)' (missing ./bootstrap/$(OS).sh)" >&2; \
		exit 1; \
	fi
	OS=$(OS) PROFILE=$(PROFILE) GROUPS="$(GROUPS)" DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./bootstrap/$(OS).sh

# Create backups and symlinks via stow.
link:
	DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./scripts/backup.sh
	DRY_RUN=$(DRY_RUN) sh ./scripts/run.sh sh ./scripts/link.sh

# Validate syntax and configuration sanity.
doctor:
	sh ./scripts/doctor.sh

# Full non-destructive test run (no package/filesystem changes).
test: doctor
	sh ./tests/run-wrapper.sh
	sh ./tests/backup-symlink.sh
	sh ./tests/dry-run-no-change.sh

# Perform the full installation (bootstrap → packages → link).
all: bootstrap packages link
