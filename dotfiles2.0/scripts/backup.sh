#!/usr/bin/env sh
#
# backup.sh -- back up existing user dotfiles before linking new ones.
#
# This script moves any conflicting dotfiles out of the way so that
# GNU stow can safely create new symlinks. Each run stores backups
# inside `~/.dotfiles_backup/<timestamp>/` preserving the directory
# structure. Only files and directories that are regular files or
# directories (not symlinks) are backed up.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"

timestamp=$(date +%Y%m%d_%H%M%S)
backup_root="$HOME/.dotfiles_backup/$timestamp"

if ! is_dry_run && [ ! -w "$HOME" ]; then
  die "[backup.sh] HOME is not writable: $HOME"
fi

is_repo_stow_symlink() {
  target="$1"
  [ -L "$target" ] || return 1
  link_target="$(readlink "$target" 2>/dev/null || true)"
  case "$link_target" in
    *"$REPO_ROOT/stow/"*) return 0 ;;
    *) return 1 ;;
  esac
}

managed_paths() {
  (
    cd "$REPO_ROOT/stow" || exit 1
    find . -mindepth 2 \( -type f -o -type l \) -print | while IFS= read -r raw_path; do
      rel_path="${raw_path#./}"
      rel_path="${rel_path#*/}"
      first="${rel_path%%/*}"
      rest=""
      second=""

      case "$rel_path" in
        */*) rest="${rel_path#*/}" ;;
      esac
      case "$rest" in
        */*) second="${rest%%/*}" ;;
        "") second="" ;;
        *) second="$rest" ;;
      esac

      case "$first" in
        .config|.local)
          if [ -n "$second" ]; then
            printf '%s/%s\n' "$first" "$second"
          else
            printf '%s\n' "$first"
          fi
          ;;
        *)
          printf '%s\n' "$first"
          ;;
      esac
    done | sort -u
  )
}

backup_if_exists() {
  # Accepts a path relative to $HOME. Backs up files/directories/symlinks unless
  # symlink is already owned by this repository's stow tree.
  rel_path="$1"
  target="$HOME/$rel_path"
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    return
  fi
  if is_repo_stow_symlink "$target"; then
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    dest="$backup_root/$rel_path"
    if is_dry_run; then
      echo "[backup.sh] Would back up $target -> $dest"
    else
      mkdir -p "$(dirname "$dest")"
      mv "$target" "$dest"
      echo "[backup.sh] Backed up $target -> $dest"
    fi
  fi
}

if ! is_dry_run; then
  mkdir -p "$backup_root"
fi

echo "[backup.sh] Scanning managed paths from $REPO_ROOT/stow"
managed_paths | while IFS= read -r item; do
  backup_if_exists "$item"
done

if is_dry_run; then
  echo "[backup.sh] Dry-run complete"
else
  echo "[backup.sh] Backup complete"
fi
