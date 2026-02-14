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

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"
MAP_FILE="$REPO_ROOT/packages/os/brew.map"
STRICT_PACKAGES="${STRICT_PACKAGES:-0}"
PROCESSED_PACKAGES=""

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "[macos.sh] Homebrew not found. Installing..."
  if is_dry_run; then
    echo "[macos.sh] [dry-run] Would run Homebrew installer"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

ensure_brew_paths_writable_or_die() {
  if is_dry_run; then
    return 0
  fi

  run_cmd mkdir -p "$HOME/Library/Caches/Homebrew" "$HOME/Library/Logs/Homebrew"

  brew_prefix="$(brew --prefix)"
  required_paths="
$HOME/Library/Caches/Homebrew
$HOME/Library/Logs/Homebrew
$brew_prefix
$brew_prefix/Cellar
$brew_prefix/bin
$brew_prefix/etc
$brew_prefix/lib
$brew_prefix/share
$brew_prefix/var/homebrew/linked
$brew_prefix/var/homebrew/locks
"

  non_writable=""
  for path in $required_paths; do
    [ -e "$path" ] || continue
    if [ ! -w "$path" ]; then
      non_writable="$non_writable $path"
    fi
  done

  if [ -n "$non_writable" ]; then
    warn "[macos.sh] Homebrew paths are not writable:$non_writable"
    die "[macos.sh] Fix ownership/permissions (e.g. sudo chown -R $(id -un) <paths>) and retry."
  fi
}

if ! command -v brew >/dev/null 2>&1; then
  if is_dry_run; then
    warn "[macos.sh] brew is missing; dry-run will skip package checks after installer preview"
    exit 0
  fi
  die "[macos.sh] Homebrew is required but not available in PATH"
fi

ensure_brew_paths_writable_or_die

# Always ensure stow is installed first
if is_dry_run; then
  echo "[macos.sh] [dry-run] Would ensure stow is installed"
  run_cmd brew install stow
elif ! brew list --versions stow >/dev/null 2>&1; then
  run_cmd brew install stow
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

is_brew_installed() {
  pkg="$1"
  if is_dry_run; then
    return 1
  fi
  brew list --versions "$pkg" >/dev/null 2>&1 || brew list --cask "$pkg" >/dev/null 2>&1
}

install_package() {
  pkg="$1"
  actual="$2"
  case " $PROCESSED_PACKAGES " in
    *" $actual "*)
      echo "[macos.sh] Skipping duplicate package $actual"
      return
      ;;
  esac
  PROCESSED_PACKAGES="$PROCESSED_PACKAGES $actual"

  if is_brew_installed "$actual"; then
    echo "[macos.sh] $actual already installed"
    return
  fi

  echo "[macos.sh] Installing $actual (from $pkg)"
  if run_cmd brew install "$actual"; then
    return
  fi

  echo "[macos.sh] Retrying $actual as cask"
  if run_cmd brew install --cask "$actual"; then
    return
  fi

  if is_truthy "$STRICT_PACKAGES"; then
    die "[macos.sh] Failed to install $actual (STRICT_PACKAGES=1)"
  fi
  warn "[macos.sh] Failed to install $actual; continuing (set STRICT_PACKAGES=1 to fail fast)"
}

install_group() {
  group="$1"
  is_valid_group "$group" || die "[macos.sh] Invalid group name: $group"
  group_file="$REPO_ROOT/packages/groups/$group.txt"
  [ -f "$group_file" ] || return
  while IFS= read -r pkg; do
    case "$pkg" in
      ""|\#*) continue ;;
    esac
    actual="$(resolve_package "$pkg")"
    if [ "$actual" = "__SKIP__" ]; then
      echo "[macos.sh] Skipping $pkg (not available on macOS)"
      continue
    fi
    install_package "$pkg" "$actual"
  done < "$group_file"
}

# Default groups if not provided
GROUPS="${GROUPS:-core}"

for g in $GROUPS; do
  install_group "$g"
done

echo "[macos.sh] Package installation complete"
