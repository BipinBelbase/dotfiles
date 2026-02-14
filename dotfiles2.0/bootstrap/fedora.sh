#!/usr/bin/env sh
#
# fedora.sh -- install packages on Fedora/RHEL/CentOS using dnf and configured package groups.
#
# Environment variables:
#   GROUPS - space separated list of package groups to install (default: core)
#
# This script updates the system, installs stow, and then installs packages defined
# in packages/groups mapped via packages/os/dnf.map.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"
MAP_FILE="$REPO_ROOT/packages/os/dnf.map"
STRICT_PACKAGES="${STRICT_PACKAGES:-0}"
PROCESSED_PACKAGES=""

command -v dnf >/dev/null 2>&1 || die "[fedora.sh] dnf not found"
command -v rpm >/dev/null 2>&1 || die "[fedora.sh] rpm not found"

echo "[fedora.sh] Updating packages"
run_cmd sudo dnf upgrade -y

# Ensure stow is installed
if ! rpm -q stow >/dev/null 2>&1; then
  echo "[fedora.sh] Installing stow"
  run_cmd sudo dnf install -y stow
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
      echo "[fedora.sh] Skipping duplicate package $actual"
      return
      ;;
  esac
  PROCESSED_PACKAGES="$PROCESSED_PACKAGES $actual"

  if rpm -q "$actual" >/dev/null 2>&1; then
    echo "[fedora.sh] $actual already installed"
    return
  fi

  echo "[fedora.sh] Installing $actual (from $pkg)"
  if run_cmd sudo dnf install -y "$actual"; then
    return
  fi

  if is_truthy "$STRICT_PACKAGES"; then
    die "[fedora.sh] Failed to install $actual (STRICT_PACKAGES=1)"
  fi
  warn "[fedora.sh] Failed to install $actual; continuing (set STRICT_PACKAGES=1 to fail fast)"
}

install_group() {
  group="$1"
  is_valid_group "$group" || die "[fedora.sh] Invalid group name: $group"
  group_file="$REPO_ROOT/packages/groups/$group.txt"
  [ -f "$group_file" ] || return
  while IFS= read -r pkg; do
    case "$pkg" in
      ""|\#*) continue ;;
    esac
    actual="$(resolve_package "$pkg")"
    if [ "$actual" = "__SKIP__" ]; then
      echo "[fedora.sh] Skipping $pkg (not available on Fedora)"
      continue
    fi
    install_package "$pkg" "$actual"
  done < "$group_file"
}

GROUPS="${GROUPS:-core}"
for g in $GROUPS; do
  install_group "$g"
done

echo "[fedora.sh] Package installation complete"
