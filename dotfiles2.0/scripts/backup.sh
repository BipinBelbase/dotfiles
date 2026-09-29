#!/usr/bin/env sh
#
# backup.sh -- back up existing user dotfiles before linking new ones.
#
# This script moves any conflicting dotfiles out of the way so that
# GNU stow can safely create new symlinks. Each run stores backups
# inside a unique `~/.dotfiles_backup/<timestamp>/` directory, preserving the
# directory structure. Conflicting symlinks are preserved too.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"

timestamp=$(date +%Y%m%d_%H%M%S)
backup_parent="$HOME/.dotfiles_backup"
backup_root="$backup_parent/$timestamp"

if ! is_dry_run && [ ! -w "$HOME" ]; then
  die "[backup.sh] HOME is not writable: $HOME"
fi

# Never reuse a prior run's destination. mkdir is atomic, so simultaneous
# installers also receive different backup directories.
suffix=1
if is_dry_run; then
  while [ -e "$backup_root" ] || [ -L "$backup_root" ]; do
    backup_root="$backup_parent/${timestamp}_$suffix"
    suffix=$((suffix + 1))
  done
else
  mkdir -p "$backup_parent"
  while ! mkdir "$backup_root" 2>/dev/null; do
    if [ ! -e "$backup_root" ] && [ ! -L "$backup_root" ]; then
      die "[backup.sh] Cannot create backup directory under $backup_parent"
    fi
    backup_root="$backup_parent/${timestamp}_$suffix"
    suffix=$((suffix + 1))
  done
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

      # Back up only the managed editor settings files. Moving all of
      # ~/Library or ~/.config/Code would also move unrelated app state.
      case "$rel_path" in
        Library/*|.config/Code/*)
          printf '%s\n' "$rel_path"
          continue
          ;;
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

echo "[backup.sh] Scanning managed paths from $REPO_ROOT/stow"
managed_paths | while IFS= read -r item; do
  backup_if_exists "$item"
done

if is_dry_run; then
  echo "[backup.sh] Dry-run complete"
else
  echo "[backup.sh] Backup complete"
fi
