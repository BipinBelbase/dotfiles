#!/usr/bin/env sh
#
# macos.sh -- install packages on macOS using Homebrew and configured package groups.
#
# Environment variables:
#   GROUPS - space separated list of package groups to install (default: core)
#
# This script assumes Homebrew is either installed or will install it. It
# installs GNU stow and then reads the group definitions under
# packages/groups and maps them to Homebrew formulae using packages/os/brew.map.

set -e

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "[macos.sh] Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Always ensure stow is installed first
brew list stow >/dev/null 2>&1 || brew install stow

# Compute repo root and mapping file
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAP_FILE="$REPO_ROOT/packages/os/brew.map"

install_group() {
  group="$1"
  group_file="$REPO_ROOT/packages/groups/$group.txt"
  [ -f "$group_file" ] || return
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    # Look up actual package name for brew
    actual="$(grep -E "^$pkg=" "$MAP_FILE" | head -n1 | cut -d= -f2)"
    [ -n "$actual" ] || actual="$pkg"
    if brew list "$actual" >/dev/null 2>&1; then
      echo "[macos.sh] $actual already installed"
    else
      echo "[macos.sh] Installing $actual"
      brew install "$actual" || true
    fi
  done < "$group_file"
}

# Default groups if not provided
GROUPS="${GROUPS:-core}"

for g in $GROUPS; do
  install_group "$g"
done

echo "[macos.sh] Package installation complete"