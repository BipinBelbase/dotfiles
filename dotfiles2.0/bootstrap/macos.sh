#!/usr/bin/env sh
#
# macos.sh -- restore the current Mac package list with Homebrew Bundle.
#
# Environment variables:
#   GROUPS - accepted for compatibility; the Mac Brewfile is the full package list.
#
# This script assumes Homebrew is either installed or will install it. It
# installs GNU stow and restores the current Mac package manifest from
# packages/Brewfile. That Brewfile includes formulae, casks, VS Code extensions,
# npm packages, and Cargo packages.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"
BREWFILE="$REPO_ROOT/packages/Brewfile"

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

[ -f "$BREWFILE" ] || die "[macos.sh] Missing package manifest: $BREWFILE"

# Always ensure stow is installed first
if is_dry_run; then
  echo "[macos.sh] [dry-run] Would ensure stow is installed"
  run_cmd brew install stow
elif ! brew list --versions stow >/dev/null 2>&1; then
  run_cmd brew install stow
fi

if is_dry_run; then
  echo "[macos.sh] [dry-run] Would restore the complete current Mac package list from $BREWFILE"
else
  run_cmd brew bundle --file "$BREWFILE" --no-lock
  # Match the current installer: avoid replacing yabai/skhd during routine upgrades.
  run_cmd brew pin skhd yabai
fi

echo "[macos.sh] Mac package restore complete"
