#!/usr/bin/env sh
#
# link.sh -- symlink configuration files using GNU stow.
#
# Before running this script, ensure that backup.sh has been executed to
# move aside any existing dotfiles. This script relies on GNU stow
# being installed on the system.

set -e

if ! command -v stow >/dev/null 2>&1; then
  echo "[link.sh] GNU stow is not installed. Please install stow first (see packages)."
  exit 1
fi

# Determine repository root (one directory above this script)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$REPO_ROOT/stow"

# Stow each module. Add new directories here as you add them to the repository.
# List of modules (subdirectories of stow) to symlink.
# Add each new module here as you introduce a new stow directory.
modules="zsh tmux nvim git ghostty yabai skhd vscode raycast"

for mod in $modules; do
  echo "[link.sh] Stowing $mod"
  stow -v -t "$HOME" "$mod"
done

echo "[link.sh] All modules linked"