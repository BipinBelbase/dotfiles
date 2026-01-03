#!/usr/bin/env sh
#
# backup.sh -- back up existing user dotfiles before linking new ones.
#
# This script moves any conflicting dotfiles out of the way so that
# GNU stow can safely create new symlinks. Each run stores backups
# inside `~/.dotfiles_backup/<timestamp>/` preserving the directory
# structure. Only files and directories that are regular files or
# directories (not symlinks) are backed up.

set -e

timestamp=$(date +%Y%m%d_%H%M%S)
backup_root="$HOME/.dotfiles_backup/$timestamp"
mkdir -p "$backup_root"

backup_if_exists() {
  # Accepts a path relative to $HOME. Backs up the file or directory if it exists and
  # is not a symlink. Symlinks are left in place since stow will overwrite them.
  rel_path="$1"
  target="$HOME/$rel_path"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    dest="$backup_root/$rel_path"
    mkdir -p "$(dirname "$dest")"
    mv "$target" "$dest"
    echo "[backup.sh] Backed up $target -> $dest"
  fi
}

# List of dotfiles/directories we manage. Extend this list as you add more stow
# modules. Only paths relative to $HOME should be listed here.
items_to_backup="
.zshrc
.zprofile
.tmux.conf
.config/nvim
.gitconfig
"

echo "[backup.sh] Backing up existing dotfiles into $backup_root"
for item in $items_to_backup; do
  backup_if_exists "$item"
done

echo "[backup.sh] Backup complete"