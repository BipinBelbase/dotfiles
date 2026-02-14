# dotfiles2.0

Production-focused, cross-platform dotfiles bootstrap with:
- OS-aware package installation (macOS, Ubuntu/Debian, Fedora, Arch)
- GNU Stow-based symlink management
- Safe dry-run mode (`--test`) that follows the same flow as real install
- Validation and smoke tests for confident public release

This guide is written so both beginners and advanced users can use it safely.

## Table Of Contents

1. [What This Project Does](#what-this-project-does)
2. [Who This Is For](#who-this-is-for)
3. [Supported Platforms](#supported-platforms)
4. [Repository Layout](#repository-layout)
5. [How Installation Works](#how-installation-works)
6. [Quick Start](#quick-start)
7. [Safe Test Mode (Recommended First)](#safe-test-mode-recommended-first)
8. [Real Installation](#real-installation)
9. [Profiles And Groups](#profiles-and-groups)
10. [Make Targets](#make-targets)
11. [Backups And Recovery](#backups-and-recovery)
12. [Troubleshooting](#troubleshooting)
13. [Security Notes](#security-notes)
14. [Developer Workflow](#developer-workflow)
15. [Public Release Checklist](#public-release-checklist)
16. [FAQ](#faq)

## What This Project Does

`dotfiles2.0` automates machine setup in three clear steps:

1. Bootstrap common directories (`~/.config`, `~/.local/bin`, `~/.cache`)
2. Install packages for your OS using curated groups/maps
3. Symlink config files from `stow/` into your home directory

The same flow can run in:
- Test mode: prints intended actions, performs no real changes
- Real mode: applies package installs, backups, and links

## Who This Is For

- Beginners setting up a new machine safely
- Developers wanting reproducible setup and low-maintenance dotfiles
- Open source maintainers who need clear behavior and validation checks

## Supported Platforms

- macOS (Homebrew)
- Ubuntu/Debian (apt)
- Fedora/RHEL-family (dnf)
- Arch Linux (pacman)

OS detection is done in:
- `/Users/bipinbelbase/dotfiles/dotfiles2.0/scripts/detect-os.sh`

## Repository Layout

```text
dotfiles2.0/
├── bootstrap/            # OS-specific package installers + common bootstrap
├── packages/
│   ├── groups/           # Logical groups (core, cli, dev, langs, gui, wm, fonts)
│   └── os/               # Package name mapping per OS
├── scripts/
│   ├── lib.sh            # Shared helpers (dry-run, logging, errors)
│   ├── doctor.sh         # Validation checks
│   ├── run.sh            # Command wrapper + logging
│   ├── backup.sh         # Backup conflicting files before stow
│   └── link.sh           # Symlink via stow (supports dry-run)
├── stow/                 # Dotfile modules
├── tests/                # Smoke tests
├── Makefile              # Main task entrypoints
└── install.sh            # One-command installer entrypoint
```

## How Installation Works

When you run the installer:

1. Detect OS
2. Validate repository (`make doctor`)
3. Bootstrap directories
4. Install package groups for your OS
5. Backup existing conflicts to `~/.dotfiles_backup/<timestamp>/`
6. Stow modules into your home directory

In dry-run (`--test`), it follows the same sequence but does not mutate your system.

## Quick Start

### Option A: Run inside this cloned repository (recommended)

```sh
cd /Users/bipinbelbase/dotfiles/dotfiles2.0
zsh ./install.sh --test
zsh ./install.sh
```

### Option B: Remote bootstrap script

```sh
curl -fsSL -o ~/install.sh https://raw.githubusercontent.com/bipinbelbase/dotfiles/dotfiles2.0/main/install.sh
chmod +x ~/install.sh
zsh ~/install.sh --test
zsh ~/install.sh
```

## Safe Test Mode (Recommended First)

Run before every real install:

```sh
zsh ./install.sh --test
```

or explicitly with profile/groups:

```sh
zsh ./install.sh --test base "core cli dev langs fonts"
```

What test mode guarantees:
- No package install execution
- No file moves in your real `HOME`
- No symlink creation in your real `HOME`
- Same flow/order as real install

Extra full checks:

```sh
make doctor
make test
```

`make test` currently verifies:
- Script/map syntax and consistency
- Wrapper exit-code correctness
- Full dry-run does not modify an isolated `HOME`

## Real Installation

After test mode is clean, run:

```sh
zsh ./install.sh
```

Custom profile/groups:

```sh
zsh ./install.sh base "core cli dev langs fonts"
zsh ./install.sh full "core cli dev langs fonts wm gui"
```

Strict package mode (fail fast on package errors):

```sh
STRICT_PACKAGES=1 make packages GROUPS="core cli dev"
```

## Profiles And Groups

### Profile

- `base` (default)
- `full` (you can define richer usage by groups)

### Groups

Defined in `/Users/bipinbelbase/dotfiles/dotfiles2.0/packages/groups/`.

Common groups:
- `core`
- `cli`
- `dev`
- `langs`
- `fonts`
- `wm`
- `gui`

Examples:

```sh
make packages GROUPS="core dev"
make all PROFILE=base GROUPS="core cli dev langs fonts"
```

## Make Targets

From `/Users/bipinbelbase/dotfiles/dotfiles2.0`:

```sh
make help
make doctor
make test
make bootstrap
make packages GROUPS="core cli"
make link
make all PROFILE=base GROUPS="core cli dev langs fonts"
make all PROFILE=base GROUPS="core cli dev langs fonts" DRY_RUN=1
```

## Backups And Recovery

Before linking, conflicts are moved to:

```text
~/.dotfiles_backup/<timestamp>/
```

To inspect latest backup:

```sh
ls -lt ~/.dotfiles_backup
```

To restore a file manually:

```sh
cp -R ~/.dotfiles_backup/<timestamp>/.zshrc ~/.zshrc
```

## Troubleshooting

### 1) `make doctor` fails

Run:

```sh
make doctor
```

Read the exact error line and fix:
- missing file
- shell syntax
- map key issues (duplicate/invalid entries)

### 2) Package install failed on real run

By default script continues for optional/unavailable packages.  
If you want strict behavior:

```sh
STRICT_PACKAGES=1 zsh ./install.sh
```

### 3) Stow conflict

Use test mode to preview:

```sh
zsh ./install.sh --test
```

Then inspect conflicting path in your home and corresponding module under:
- `/Users/bipinbelbase/dotfiles/dotfiles2.0/stow/`

### 4) OS mismatch

Check detected OS:

```sh
sh ./scripts/detect-os.sh
```

Ensure matching script exists in:
- `/Users/bipinbelbase/dotfiles/dotfiles2.0/bootstrap/`

### 5) View logs from real runs

Real runs write logs in:
- `/Users/bipinbelbase/dotfiles/dotfiles2.0/.logs/`

## Security Notes

- Group names are validated to block malformed input.
- Test mode avoids side effects in your real environment.
- Package mappings are explicit per OS.
- No hidden background services are configured by default.

Still review scripts before running on sensitive machines.

## Developer Workflow

Recommended loop before commit/publish:

```sh
make doctor
make test
zsh ./install.sh --test base "core cli dev langs fonts"
```

Optional real verification:

```sh
zsh ./install.sh base "core"
```

## Public Release Checklist

Before making repository public:

1. `make doctor` passes.
2. `make test` passes.
3. `install.sh --test` passes with expected groups.
4. Real install run completes on your primary OS.
5. Review `stow/` for secrets (tokens, API keys, personal paths).
6. Validate README commands from a clean shell session.
7. Commit with clear changelog/release notes.

## FAQ

### Should I run test mode first every time?

Yes. It catches map/script/link issues without changing your machine.

### Can I run only link step?

Yes:

```sh
make link
```

### Can I skip packages and just use stow?

Yes:

```sh
make bootstrap
make link
```

### Can I extend package groups?

Yes. Add package keys to:
- `/Users/bipinbelbase/dotfiles/dotfiles2.0/packages/groups/*.txt`

Then map them in:
- `/Users/bipinbelbase/dotfiles/dotfiles2.0/packages/os/*.map`

Run `make doctor` afterward.
