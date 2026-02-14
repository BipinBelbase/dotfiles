#!/usr/bin/env sh
#
# backup-symlink.sh -- ensure non-stow symlink conflicts are backed up.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_HOME="$(mktemp -d /tmp/dotfiles2-home.XXXXXX)"
trap 'rm -rf "$TMP_HOME"' EXIT INT TERM

mkdir -p "$TMP_HOME/.config"
ln -s "/tmp/not-managed-by-stow" "$TMP_HOME/.config/ghostty"

echo "[test][backup-symlink] Running backup against symlink conflict"
HOME="$TMP_HOME" DRY_RUN=0 sh "$REPO_ROOT/scripts/backup.sh"

if [ -e "$TMP_HOME/.config/ghostty" ] || [ -L "$TMP_HOME/.config/ghostty" ]; then
  echo "[test][backup-symlink][error] conflict symlink was not moved" >&2
  exit 1
fi

if ! find "$TMP_HOME/.dotfiles_backup" -type l -name ghostty -print -quit | grep -q .; then
  echo "[test][backup-symlink][error] conflict symlink not found in backup" >&2
  exit 1
fi

echo "[test][backup-symlink] Passed"
