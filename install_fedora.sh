#!/usr/bin/env bash
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
  printf '%s\n' 'Cannot identify this operating system.' >&2
  exit 1
fi
# shellcheck disable=SC1091
source /etc/os-release
if [[ "${ID:-}" != fedora ]]; then
  printf 'This installer supports Fedora; detected %s.\n' "${PRETTY_NAME:-unknown}" >&2
  exit 1
fi

usage() {
  printf 'Usage: %s {packages|bash|tmux|nvim}\n' "${0##*/}"
}

component=${1:-}
case "$component" in
  packages|bash|tmux|nvim) ;;
  *) usage >&2; exit 2 ;;
esac

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
backup_suffix=$(date +%Y%m%d-%H%M%S)

if [[ "$component" == packages ]]; then
  mapfile -t packages < <(sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$repo_root/packages/fedora-core.txt")
  if ((${#packages[@]})); then
    sudo dnf install -y "${packages[@]}"
  fi
  exit
fi

link_file() {
  local source=$1 destination=$2 backup candidate number
  mkdir -p -- "$(dirname -- "$destination")"

  if [[ -L "$destination" && "$(readlink -- "$destination")" == "$source" ]]; then
    printf 'Already linked: %s\n' "$destination"
    return
  fi

  if [[ -e "$destination" || -L "$destination" ]]; then
    backup="${destination}.dotfiles-backup-${backup_suffix}"
    candidate=$backup
    number=1
    while [[ -e "$candidate" || -L "$candidate" ]]; do
      candidate="${backup}-${number}"
      ((number += 1))
    done
    mv -- "$destination" "$candidate"
    printf 'Preserved existing file at %s\n' "$candidate"
  fi

  ln -s -- "$source" "$destination"
  printf 'Linked %s -> %s\n' "$destination" "$source"
}

if [[ "$component" == bash ]]; then
  link_file "$repo_root/stow/fedora-bash/.bashrc" "$HOME/.bashrc"
fi

if [[ "$component" == tmux ]]; then
  for name in tmux-sessionizer dotfiles-copy dotfiles-open open; do
    link_file "$repo_root/stow/linux-tmux/.local/bin/$name" "$HOME/.local/bin/$name"
  done
  link_file "$repo_root/stow/linux-tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

if [[ "$component" == nvim ]]; then
  link_file "$repo_root/stow/nvim/.config/nvim" "$HOME/.config/nvim"
fi
