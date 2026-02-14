#!/usr/bin/env sh
#
# link.sh -- symlink configuration files using GNU stow.
#
# Before running this script, ensure that backup.sh has been executed to
# move aside any existing dotfiles. This script relies on GNU stow
# being installed on the system.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"

if ! command -v stow >/dev/null 2>&1; then
  die "[link.sh] GNU stow is not installed. Please install stow first (see packages)."
fi

if [ ! -d "$HOME" ]; then
  die "[link.sh] HOME directory does not exist: $HOME"
fi

STOW_DIR="$REPO_ROOT/stow"
[ -d "$STOW_DIR" ] || die "[link.sh] Missing stow directory: $STOW_DIR"
cd "$STOW_DIR"

modules="${MODULES:-$(find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)}"
[ -n "$modules" ] || die "[link.sh] No stow modules found in $STOW_DIR"

managed_paths() {
  (
    cd "$STOW_DIR" || exit 1
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

is_repo_stow_symlink() {
  target="$1"
  [ -L "$target" ] || return 1
  link_target="$(readlink "$target" 2>/dev/null || true)"
  case "$link_target" in
    *"$REPO_ROOT/stow/"*) return 0 ;;
    *) return 1 ;;
  esac
}

target_home="$HOME"
tmp_home=""

if is_dry_run; then
  tmp_home="$(mktemp -d /tmp/dotfiles2-linkcheck.XXXXXX)"
  target_home="$tmp_home"
  trap 'rm -rf "$tmp_home"' EXIT INT TERM

  # Seed temporary HOME with only managed non-symlink paths and run a real backup
  # there so stow checks represent post-backup behavior without touching real HOME.
  managed_paths | while IFS= read -r rel_path; do
    src="$HOME/$rel_path"
    dest="$target_home/$rel_path"
    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
      continue
    fi
    if is_repo_stow_symlink "$src"; then
      continue
    fi
    if [ -L "$src" ]; then
      link_target="$(readlink "$src" 2>/dev/null || true)"
      mkdir -p "$(dirname "$dest")"
      ln -s "$link_target" "$dest"
    elif [ -e "$src" ]; then
      mkdir -p "$(dirname "$dest")"
      cp -R "$src" "$dest"
    fi
  done

  HOME="$target_home" DRY_RUN=0 sh "$REPO_ROOT/scripts/backup.sh" >/dev/null
  echo "[link.sh] Dry-run uses temporary HOME=$target_home"
fi

for mod in $modules; do
  [ -d "$STOW_DIR/$mod" ] || die "[link.sh] Stow module not found: $mod"
  if is_dry_run; then
    echo "[link.sh] Dry-run stow check for $mod"
    stow -n -v -t "$target_home" "$mod"
  else
    echo "[link.sh] Stowing $mod"
    stow -v -t "$target_home" "$mod"
  fi
done

if is_dry_run; then
  echo "[link.sh] Dry-run complete"
else
  echo "[link.sh] All modules linked"
fi
