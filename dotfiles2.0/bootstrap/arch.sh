#!/usr/bin/env sh
#
# arch.sh -- install packages on Arch Linux using pacman and configured package groups.
#
# Environment variables:
#   GROUPS - space separated list of package groups to install (default: core)
#
# This script updates the system, ensures stow is installed, and then
# installs packages defined in packages/groups mapped via packages/os/pacman.map.

set -e

# Update package database and upgrade existing packages
echo "[arch.sh] Updating system"
sudo pacman -Syu --noconfirm

# Ensure stow is installed
if ! pacman -Qi stow >/dev/null 2>&1; then
  echo "[arch.sh] Installing stow"
  sudo pacman -S --noconfirm stow
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAP_FILE="$REPO_ROOT/packages/os/pacman.map"

install_group() {
  group="$1"
  group_file="$REPO_ROOT/packages/groups/$group.txt"
  [ -f "$group_file" ] || return
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    actual="$(grep -E "^$pkg=" "$MAP_FILE" | head -n1 | cut -d= -f2)"
    [ -n "$actual" ] || actual="$pkg"
    if pacman -Qi "$actual" >/dev/null 2>&1; then
      echo "[arch.sh] $actual already installed"
    else
      echo "[arch.sh] Installing $actual"
      sudo pacman -S --noconfirm "$actual" || true
    fi
  done < "$group_file"
}

GROUPS="${GROUPS:-core}"
for g in $GROUPS; do
  install_group "$g"
done

echo "[arch.sh] Package installation complete"