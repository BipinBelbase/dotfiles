OS := $(shell ./scripts/detect-os.sh)
PROFILE ?= base
GROUPS ?= core

.DEFAULT_GOAL := help

# Help target shows available make goals and usage examples.
help:
	@echo "Targets:"
	@echo "  make bootstrap            # minimal prerequisites"
	@echo "  make packages PROFILE=...  # install package groups"
	@echo "  make link                 # symlink dotfiles"
	@echo "  make all PROFILE=full     # full setup"
	@echo ""
	@echo "Examples:"
	@echo "  make all PROFILE=base"
	@echo "  make packages GROUPS='core dev gui'"

# Prepare minimal environment (create common directories, etc).
bootstrap:
	./scripts/run.sh ./bootstrap/common.sh

# Install package groups according to the detected OS.
packages:
	OS=$(OS) PROFILE=$(PROFILE) GROUPS="$(GROUPS)" ./scripts/run.sh ./bootstrap/$(OS).sh

# Create backups and symlinks via stow.
link:
	./scripts/run.sh ./scripts/backup.sh
	./scripts/run.sh ./scripts/link.sh

# Perform the full installation (bootstrap → packages → link).
all: bootstrap packages link