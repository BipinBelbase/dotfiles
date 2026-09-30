#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$script_dir
dry_run=false
nvim_only=false
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

usage() {
  printf 'Usage: %s [--dry-run|--nvim-only]\n' "${0##*/}"
  printf '%s\n' 'Detects Fedora, Arch, Debian, or Ubuntu; installs portable tools and links their configs.'
}

case "${1:-}" in
  --dry-run) dry_run=true ;;
  --nvim-only) nvim_only=true ;;
  -h|--help) usage; exit 0 ;;
  "") ;;
  *) usage >&2; exit 2 ;;
esac

if [[ $EUID -eq 0 ]]; then
  printf '%s\n' 'Run this installer as your normal user; it calls sudo only for system packages.' >&2
  exit 1
fi
if [[ ! -r /etc/os-release ]]; then
  printf '%s\n' 'Cannot identify this Linux distribution.' >&2
  exit 1
fi
# shellcheck disable=SC1091
source /etc/os-release

family=
case "${ID:-}" in
  fedora) family=fedora ;;
  arch|manjaro|endeavouros|artix) family=arch ;;
  debian|ubuntu|linuxmint|pop|elementary|zorin) family=debian ;;
  *)
    case " ${ID_LIKE:-} " in
      *" fedora "*|*" rhel "*) family=fedora ;;
      *" arch "*) family=arch ;;
      *" debian "*|*" ubuntu "*) family=debian ;;
    esac
    ;;
esac

if [[ -z "$family" ]]; then
  printf 'Unsupported Linux distribution: %s (%s).\n' "${PRETTY_NAME:-unknown}" "${ID:-unknown}" >&2
  printf '%s\n' 'Supported families are Fedora/RHEL, Arch, and Debian/Ubuntu.' >&2
  exit 1
fi

required_file="$repo_root/packages/linux/${family}-required.txt"
optional_file="$repo_root/packages/linux/${family}-optional.txt"
if [[ ! -r "$required_file" || ! -r "$optional_file" ]]; then
  printf 'Package map missing for %s.\n' "$family" >&2
  exit 1
fi

read_packages() {
  sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$1"
}

mapfile -t required_packages < <(read_packages "$required_file")
mapfile -t optional_packages < <(read_packages "$optional_file")

say() { printf '%s\n' "$*"; }

install_packages() {
  local package available
  local -a available_optional=()
  local -a available_names=()

  case "$family" in
    debian)
      if $dry_run; then
        say 'Would run: sudo apt-get update'
      else
        sudo apt-get update
      fi
      for package in "${optional_packages[@]}"; do
        if $dry_run || apt-cache show "$package" >/dev/null 2>&1; then
          available_optional+=("$package")
        else
          say "Skipping optional package not found in enabled APT sources: $package"
        fi
      done
      if $dry_run; then
        printf 'Would install required: %s\n' "${required_packages[*]}"
        printf 'Would install available optional: %s\n' "${available_optional[*]}"
      else
        sudo apt-get install -y "${required_packages[@]}" "${available_optional[@]}"
      fi
      ;;
    fedora)
      mapfile -t available_names < <(dnf -q repoquery --available --qf $'%{name}\n' "${optional_packages[@]}")
      for package in "${optional_packages[@]}"; do
        available=false
        for available_name in "${available_names[@]}"; do
          if [[ "$available_name" == "$package" ]]; then available=true; break; fi
        done
        if $available; then available_optional+=("$package"); else say "Skipping optional package unavailable in Fedora repositories: $package"; fi
      done
      if $dry_run; then
        printf 'Would run: sudo dnf install -y %s %s\n' "${required_packages[*]}" "${available_optional[*]}"
      else
        sudo dnf install -y "${required_packages[@]}" "${available_optional[@]}"
      fi
      ;;
    arch)
      for package in "${optional_packages[@]}"; do
        if pacman -Si "$package" >/dev/null 2>&1; then
          available_optional+=("$package")
        else
          say "Skipping optional package unavailable in Arch repositories: $package"
        fi
      done
      if $dry_run; then
        printf 'Would run: sudo pacman -S --needed %s %s\n' "${required_packages[*]}" "${available_optional[*]}"
      else
        sudo pacman -S --needed --noconfirm "${required_packages[@]}" "${available_optional[@]}"
      fi
      ;;
  esac
}

timestamp=$(date +%Y%m%d-%H%M%S)
link_file() {
  local source=$1 destination=$2 backup candidate number
  if [[ ! -e "$source" ]]; then
    say "Skipping missing source: $source"
    return
  fi
  if $dry_run; then
    say "Would link $destination -> $source (back up any existing file first)"
    return
  fi
  mkdir -p -- "$(dirname -- "$destination")"
  if [[ -L "$destination" && "$(readlink -- "$destination")" == "$source" ]]; then
    say "Already linked: $destination"
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    backup="${destination}.dotfiles-backup-${timestamp}"
    candidate=$backup
    number=1
    while [[ -e "$candidate" || -L "$candidate" ]]; do
      candidate="${backup}-${number}"
      ((number += 1))
    done
    mv -- "$destination" "$candidate"
    say "Preserved existing path at $candidate"
  fi
  ln -s -- "$source" "$destination"
  say "Linked $destination -> $source"
}

install_newer_neovim_if_needed() {
  local current version major minor patch asset archive temp_dir extracted install_dir wrapper_tmp
  if $dry_run; then
    say 'Would check the installed Neovim version after package installation and use the official release archive if it is older than 0.12.'
    return
  fi
  current=$(command -v nvim 2>/dev/null || true)
  version=
  if [[ -n "$current" ]]; then
    version=$("$current" --version 2>/dev/null | sed -n '1s/.*v\([0-9][0-9.]*\).*/\1/p')
  fi
  major=${version%%.*}
  minor=${version#*.}; minor=${minor%%.*}
  patch=${version##*.}
  [[ "$major" =~ ^[0-9]+$ ]] || major=0
  [[ "$minor" =~ ^[0-9]+$ ]] || minor=0
  [[ "$patch" =~ ^[0-9]+$ ]] || patch=0
  if ((major > 0 || minor >= 12)); then
    say "Neovim $version is new enough for this configuration."
    return
  fi

  case "$(uname -m)" in
    x86_64|amd64) asset=x86_64 ;;
    aarch64|arm64) asset=arm64 ;;
    *)
      say "Neovim 0.12+ is required, and no upstream binary is mapped for $(uname -m)."
      return 1
      ;;
  esac
  mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
  temp_dir=$(mktemp -d "$HOME/.local/opt/nvim-download.XXXXXX")
  trap '[[ -z "${temp_dir:-}" ]] || rm -rf -- "$temp_dir"' RETURN
  curl -fL --retry 3 "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${asset}.tar.gz" -o "$temp_dir/nvim.tar.gz"
  tar -xzf "$temp_dir/nvim.tar.gz" -C "$temp_dir"
  extracted="$temp_dir/nvim-linux-${asset}"
  install_dir="$HOME/.local/opt/nvim"
  if [[ -e "$install_dir" ]]; then
    mv -- "$install_dir" "${install_dir}.backup-${timestamp}"
  fi
  mv -- "$extracted" "$install_dir"

  wrapper_tmp="$HOME/.local/bin/.nvim-wrapper.$$"
  cat >"$wrapper_tmp" <<'WRAPPER'
#!/usr/bin/env bash
set -e
export VIMRUNTIME="$HOME/.local/opt/nvim/share/nvim/runtime"
exec "$HOME/.local/opt/nvim/bin/nvim" "$@"
WRAPPER
  chmod +x "$wrapper_tmp"
  if [[ -e "$HOME/.local/bin/nvim" || -L "$HOME/.local/bin/nvim" ]]; then
    mv -- "$HOME/.local/bin/nvim" "$HOME/.local/bin/nvim.backup-${timestamp}"
  fi
  mv -- "$wrapper_tmp" "$HOME/.local/bin/nvim"
  say 'Installed the official Neovim release under ~/.local/opt/nvim.'
}

install_nerd_font_if_needed() {
  local font_dir temp_dir
  if command -v fc-list >/dev/null 2>&1 && fc-list : family | grep -Fq 'JetBrainsMono Nerd Font'; then
    say 'JetBrainsMono Nerd Font is already installed.'
    return
  fi
  if $dry_run; then
    say 'Would install the JetBrainsMono Nerd Font for Powerlevel10k and terminal icons.'
    return
  fi
  if ! command -v fc-cache >/dev/null 2>&1; then
    say 'Fontconfig is unavailable; skipping the optional Nerd Font.'
    return
  fi

  temp_dir=$(mktemp -d)
  curl -fL --retry 3 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz' -o "$temp_dir/font.tar.xz"
  mkdir -p "$temp_dir/extracted"
  tar -xJf "$temp_dir/font.tar.xz" -C "$temp_dir/extracted"
  font_dir="$HOME/.local/share/fonts/dotfiles/JetBrainsMono"
  if [[ -e "$font_dir" ]]; then
    mv -- "$font_dir" "${font_dir}.backup-${timestamp}"
  fi
  mkdir -p "$font_dir"
  find "$temp_dir/extracted" -type f \( -name '*.ttf' -o -name '*.otf' \) -exec cp -f -- '{}' "$font_dir/" \;
  rm -rf -- "$temp_dir"
  fc-cache -f "$font_dir"
  say 'Installed the JetBrainsMono Nerd Font under ~/.local/share/fonts.'
}

install_minikube_if_needed() {
  local asset temp_binary destination
  if command -v minikube >/dev/null 2>&1; then
    say "Minikube is already installed: $(command -v minikube)"
    return
  fi
  case "$(uname -m)" in
    x86_64|amd64) asset=amd64 ;;
    aarch64|arm64) asset=arm64 ;;
    *) say "No Minikube binary is mapped for $(uname -m); skipping it."; return ;;
  esac
  if $dry_run; then
    say "Would install the official Linux $asset Minikube binary into ~/.local/bin."
    return
  fi
  mkdir -p "$HOME/.local/bin"
  temp_binary=$(mktemp "$HOME/.local/bin/.minikube.XXXXXX")
  curl -fL --retry 3 "https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-${asset}" -o "$temp_binary"
  chmod 0755 "$temp_binary"
  destination="$HOME/.local/bin/minikube"
  if [[ -e "$destination" || -L "$destination" ]]; then
    mv -- "$destination" "${destination}.backup-${timestamp}"
  fi
  mv -- "$temp_binary" "$destination"
  say 'Installed Minikube under ~/.local/bin. A container runtime is required before starting a cluster.'
}

install_user_dev_tools() {
  local -a npm_packages=()
  mapfile -t npm_packages < <(read_packages "$repo_root/packages/npm-global.txt")
  if command -v npm >/dev/null 2>&1; then
    if $dry_run; then
      say "Would install user-local npm tools: ${npm_packages[*]}"
    elif ! npm install --global --prefix "$HOME/.local" "${npm_packages[@]}"; then
      say 'Some npm tools could not be installed. Retry after checking the npm output above.'
    fi
  elif $dry_run && printf '%s\n' "${required_packages[@]}" "${optional_packages[@]}" | grep -Eq '^(nodejs-npm|npm)$'; then
    say "Would install user-local npm tools after the distro package manager installs npm: ${npm_packages[*]}"
  else
    say 'npm is unavailable; skipping user-local JavaScript tools.'
  fi

  if command -v cargo >/dev/null 2>&1; then
    if $dry_run; then
      say 'Would install Rustlings with Cargo.'
    elif ! cargo install --locked rustlings; then
      say 'Rustlings could not be installed. Retry with: cargo install --locked rustlings'
    fi
  elif $dry_run && printf '%s\n' "${required_packages[@]}" "${optional_packages[@]}" | grep -Eq '^(cargo|rust)$'; then
    say 'Would install Rustlings after the distro package manager installs Cargo.'
  else
    say 'Cargo is unavailable; skipping Rustlings.'
  fi
}

if $nvim_only; then
  install_newer_neovim_if_needed
  exit 0
fi

clone_if_missing() {
  local url=$1 destination=$2
  if [[ -d "$destination/.git" ]]; then
    say "Already installed: $destination"
  elif $dry_run; then
    say "Would clone $url into $destination"
  else
    mkdir -p -- "$(dirname -- "$destination")"
    git clone --depth 1 "$url" "$destination" || say "Could not clone $url; continuing without it."
  fi
}

if $dry_run; then
  say "Detected ${PRETTY_NAME:-Linux} (package family: $family)."
else
  say "Installing the portable dotfiles profile for ${PRETTY_NAME:-Linux}."
fi
install_packages
install_nerd_font_if_needed
install_minikube_if_needed
install_user_dev_tools

link_file "$repo_root/stow/fedora-bash/.bashrc" "$HOME/.bashrc"
link_file "$repo_root/stow/linux-zsh/.zshrc" "$HOME/.zshrc"
link_file "$repo_root/stow/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_file "$repo_root/stow/linux-tmux/.tmux.conf" "$HOME/.tmux.conf"
for name in tmux-sessionizer dotfiles-copy dotfiles-open open; do
  link_file "$repo_root/stow/linux-tmux/.local/bin/$name" "$HOME/.local/bin/$name"
done
link_file "$repo_root/stow/nvim/.config/nvim" "$HOME/.config/nvim"
link_file "$repo_root/stow/ideavim/.ideavimrc" "$HOME/.ideavimrc"
link_file "$repo_root/stow/linux-ghostty/.config/ghostty/config" "$HOME/.config/ghostty/config"
if [[ "$family" == arch ]]; then
  code_user_dir="$HOME/.config/Code - OSS/User"
else
  code_user_dir="$HOME/.config/Code/User"
fi
code_source="$repo_root/stow/vscode/Library/Application Support/Code/User"
for code_file in settings.json keybindings.json tasks.json; do
  link_file "$code_source/$code_file" "$code_user_dir/$code_file"
done

install_newer_neovim_if_needed

clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
if [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
  if $dry_run; then
    say 'Would install plugins configured in ~/.tmux.conf via TPM.'
  else
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || say 'TPM could not install all tmux plugins; retry with prefix + I inside tmux.'
  fi
fi

zsh_path=$(command -v zsh || true)
if $dry_run; then
  say 'Would set Zsh as the login shell after package installation if it is listed in /etc/shells.'
elif [[ -n "$zsh_path" ]]; then
  if grep -Fxq "$zsh_path" /etc/shells && [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]]; then
    sudo chsh -s "$zsh_path" "$USER" || say "Could not change the login shell automatically. Run: chsh -s $zsh_path"
  fi
fi

if $dry_run; then
  say 'Dry run finished; no packages, files, shells, or plugins were changed.'
else
  say 'Linux dotfiles setup finished. Log out and back in to start the configured Zsh login shell.'
fi
