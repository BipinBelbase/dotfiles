#!/usr/bin/env sh
#
# ubuntu.sh -- install packages on Ubuntu/Debian using apt and configured package groups.
#
# Environment variables:
#   GROUPS - space separated list of package groups to install (default: core)
#
# This script updates apt, installs stow, and then installs packages defined
# in packages/groups mapped via packages/os/apt.map.

set -e

echo "[ubuntu.sh] Updating package list"
sudo apt-get update -y

# Ensure stow is installed
if ! dpkg -s stow >/dev/null 2>&1; then
  echo "[ubuntu.sh] Installing stow"
  sudo apt-get install -y stow
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAP_FILE="$REPO_ROOT/packages/os/apt.map"

install_group() {
  group="$1"
  group_file="$REPO_ROOT/packages/groups/$group.txt"
  [ -f "$group_file" ] || return
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    actual="$(grep -E "^$pkg=" "$MAP_FILE" | head -n1 | cut -d= -f2)"
    [ -n "$actual" ] || actual="$pkg"
    if dpkg -s "$actual" >/dev/null 2>&1; then
      echo "[ubuntu.sh] $actual already installed"
    else
      echo "[ubuntu.sh] Installing $actual"
      sudo apt-get install -y "$actual" || true
    fi
  done < "$group_file"
}

GROUPS="${GROUPS:-core}"
for g in $GROUPS; do
  install_group "$g"
done

echo "[ubuntu.sh] Package installation complete"