#!/usr/bin/env zsh
set -euo pipefail

# ----------------------------
# Logging helpers
# ----------------------------
log()  { print -r -- "[install] $*"; }
warn() { print -r -- "[install][warn] $*" >&2; }
die()  { print -r -- "[install][error] $*" >&2; exit 1; }

# ----------------------------
# Resolve repo root (script dir)
# ----------------------------
REPO_ROOT="${0:A:h}"
cd "$REPO_ROOT" || die "Cannot cd to repo root: $REPO_ROOT"

[[ -f "$REPO_ROOT/Makefile" ]] || die "Makefile not found in $REPO_ROOT. Put this script in the dotfiles repo root."

# ----------------------------
# Detect OS
# ----------------------------
detect_os() {
  local uname_s
  uname_s="$(uname -s)"

  if [[ "$uname_s" == "Darwin" ]]; then
    print -r -- "macos"
    return 0
  fi

  if [[ "$uname_s" == "Linux" ]]; then
    # WSL is Linux: treat it as ubuntu-like for packages
    if [[ -r /proc/version ]] && grep -qi "microsoft" /proc/version; then
      print -r -- "ubuntu"
      return 0
    fi

    if [[ -f /etc/arch-release ]]; then
      print -r -- "arch"
      return 0
    elif [[ -f /etc/fedora-release ]]; then
      print -r -- "fedora"
      return 0
    else
      # Default to ubuntu/debian family
      print -r -- "ubuntu"
      return 0
    fi
  fi

  die "Unsupported OS: $(uname -s)"
}

OS="$(detect_os)"
log "Detected OS: $OS"

# ----------------------------
# Install minimal prereqs (curl/git/make)
# We intentionally keep this minimal and stable.
# ----------------------------
have() { command -v "$1" >/dev/null 2>&1 }

need_cmd_or_die() {
  local cmd="$1" hint="$2"
  have "$cmd" || die "Missing required command: $cmd. ${hint}"
}

install_prereqs_macos() {
  # On a fresh macOS, "make" requires Xcode Command Line Tools
  if ! have make; then
    warn "make not found. Installing Xcode Command Line Tools..."
    xcode-select --install >/dev/null 2>&1 || true
    die "Xcode Command Line Tools installer opened. After it finishes, re-run: zsh ./install.sh"
  fi

  # curl and git usually exist; verify anyway
  need_cmd_or_die curl "curl should exist on macOS. If not, install Xcode Command Line Tools."
  if ! have git; then
    warn "git not found. Installing Xcode Command Line Tools (git comes with it)..."
    xcode-select --install >/dev/null 2>&1 || true
    die "Xcode Command Line Tools installer opened. After it finishes, re-run: zsh ./install.sh"
  fi
}

install_prereqs_ubuntu() {
  # Ask for sudo once up-front (less headache later)
  log "Requesting sudo (needed for package installs)..."
  sudo -v

  if ! have apt-get; then
    die "apt-get not found. This script expects Ubuntu/Debian (or WSL Ubuntu)."
  fi

  # Ensure basic tooling
  sudo apt-get update -y
  sudo apt-get install -y curl git make
}

install_prereqs_fedora() {
  log "Requesting sudo (needed for package installs)..."
  sudo -v

  if ! have dnf; then
    die "dnf not found. This script expects Fedora/RHEL-like systems."
  fi

  sudo dnf -y install curl git make
}

install_prereqs_arch() {
  log "Requesting sudo (needed for package installs)..."
  sudo -v

  if ! have pacman; then
    die "pacman not found. This script expects Arch Linux."
  fi

  sudo pacman -Sy --noconfirm
  sudo pacman -S --noconfirm curl git make
}

case "$OS" in
  macos)  install_prereqs_macos ;;
  ubuntu) install_prereqs_ubuntu ;;
  fedora) install_prereqs_fedora ;;
  arch)   install_prereqs_arch ;;
  *)      die "No prereq installer for OS=$OS" ;;
esac

# ----------------------------
# Choose PROFILE and GROUPS
# - PROFILE: base|full (your Makefile defaults to base)
# - GROUPS: space-separated package groups (your Makefile defaults to core)
#
# Usage:
#   zsh ./install.sh
#   zsh ./install.sh full
#   zsh ./install.sh base "core cli dev langs fonts"
# ----------------------------
PROFILE="${1:-base}"

# OS-safe defaults to avoid noisy “package not found” on Linux GUI packages.
if [[ $# -ge 2 ]]; then
  GROUPS="$2"
else
  if [[ "$OS" == "macos" ]]; then
    # macOS: you actually use yabai/skhd + GUI apps
    GROUPS="core cli dev langs fonts wm gui"
  else
    # Linux: keep defaults tight and reliable; you can add gui later if desired
    GROUPS="core cli dev langs fonts"
  fi
fi

log "PROFILE=$PROFILE"
log "GROUPS=$GROUPS"

# ----------------------------
# Run your repo workflow
# ----------------------------
log "Running: make all PROFILE=$PROFILE GROUPS=\"$GROUPS\""
make all PROFILE="$PROFILE" GROUPS="$GROUPS"

log "Done."
log "If something changed, restart your terminal (or source ~/.zshrc)."
