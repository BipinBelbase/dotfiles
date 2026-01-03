#!/usr/bin/env sh
#
# fedora.sh -- install packages on Fedora/RHEL/CentOS using dnf and configured package groups.
#
# Environment variables:
#   GROUPS - space separated list of package groups to install (default: core)
#
# This script updates the system, installs stow, and then installs packages defined
# in packages/groups mapped via packages/os/dnf.map.

set -e

echo "[fedora.sh] Updating packages"
sudo dnf upgrade -y

# Ensure stow is installed
if ! rpm -q stow >/dev/null 2>&1; then
  echo "[fedora.sh] Installing stow"
  sudo dnf install -y stow
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAP_FILE="$REPO_ROOT/packages/os/dnf.map"

install_group() {
  group="$1"
  group_file="$REPO_ROOT/packages/groups/$group.txt"
  [ -f "$group_file" ] || return
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    actual="$(grep -E "^$pkg=" "$MAP_FILE" | head -n1 | cut -d= -f2)"
    [ -n "$actual" ] || actual="$pkg"
    if rpm -q "$actual" >/dev/null 2>&1; then
      echo "[fedora.sh] $actual already installed"
    else
      echo "[fedora.sh] Installing $actual"
      sudo dnf install -y "$actual" || true
    fi
  done < "$group_file"
}

GROUPS="${GROUPS:-core}"
for g in $GROUPS; do
  install_group "$g"
done

echo "[fedora.sh] Package installation complete"