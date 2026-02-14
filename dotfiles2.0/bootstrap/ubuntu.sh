#!/usr/bin/env sh
#
# ubuntu.sh -- install packages on Ubuntu/Debian using apt and configured package groups.
#
# Environment variables:
#   GROUPS - space separated list of package groups to install (default: core)
#
# This script updates apt, installs stow, and then installs packages defined
# in packages/groups mapped via packages/os/apt.map.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"
MAP_FILE="$REPO_ROOT/packages/os/apt.map"
STRICT_PACKAGES="${STRICT_PACKAGES:-0}"
PROCESSED_PACKAGES=""

command -v apt-get >/dev/null 2>&1 || die "[ubuntu.sh] apt-get not found"
command -v dpkg >/dev/null 2>&1 || die "[ubuntu.sh] dpkg not found"

echo "[ubuntu.sh] Updating package list"
run_cmd sudo apt-get update -y

# Ensure stow is installed
if ! dpkg -s stow >/dev/null 2>&1; then
  echo "[ubuntu.sh] Installing stow"
  run_cmd sudo apt-get install -y stow
fi

resolve_package() {
  pkg="$1"
  line="$(awk -F= -v key="$pkg" '$1==key {print; exit}' "$MAP_FILE")"
  if [ -z "$line" ]; then
    printf '%s\n' "$pkg"
    return
  fi

  mapped="${line#*=}"
  mapped="${mapped%%#*}"
  mapped="$(printf '%s' "$mapped" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

  if [ -z "$mapped" ]; then
    printf '%s\n' "__SKIP__"
  else
    printf '%s\n' "$mapped"
  fi
}

is_valid_group() {
  case "$1" in
    *[!A-Za-z0-9_-]*|"") return 1 ;;
    *) return 0 ;;
  esac
}

install_package() {
  pkg="$1"
  actual="$2"
  case " $PROCESSED_PACKAGES " in
    *" $actual "*)
      echo "[ubuntu.sh] Skipping duplicate package $actual"
      return
      ;;
  esac
  PROCESSED_PACKAGES="$PROCESSED_PACKAGES $actual"

  if dpkg -s "$actual" >/dev/null 2>&1; then
    echo "[ubuntu.sh] $actual already installed"
    return
  fi

  echo "[ubuntu.sh] Installing $actual (from $pkg)"
  if run_cmd sudo apt-get install -y "$actual"; then
    return
  fi

  if is_truthy "$STRICT_PACKAGES"; then
    die "[ubuntu.sh] Failed to install $actual (STRICT_PACKAGES=1)"
  fi
  warn "[ubuntu.sh] Failed to install $actual; continuing (set STRICT_PACKAGES=1 to fail fast)"
}

install_group() {
  group="$1"
  is_valid_group "$group" || die "[ubuntu.sh] Invalid group name: $group"
  group_file="$REPO_ROOT/packages/groups/$group.txt"
  [ -f "$group_file" ] || return
  while IFS= read -r pkg; do
    case "$pkg" in
      ""|\#*) continue ;;
    esac
    actual="$(resolve_package "$pkg")"
    if [ "$actual" = "__SKIP__" ]; then
      echo "[ubuntu.sh] Skipping $pkg (not available on Ubuntu)"
      continue
    fi
    install_package "$pkg" "$actual"
  done < "$group_file"
}

GROUPS="${GROUPS:-core}"
for g in $GROUPS; do
  install_group "$g"
done

echo "[ubuntu.sh] Package installation complete"
