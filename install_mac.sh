#!/usr/bin/env bash
# first run this below things
# curl -fsSL -o ~/install_mac.sh https://raw.githubusercontent.com/bipinbelbase/dotfiles/main/install_mac.sh && chmod +x ~/install_mac.sh && ~/install_mac.sh
set -euo pipefail
IFS=$'\n\t'

echo "🚀 Starting Mac setup..."

# Countdown for dramatic effect
for i in 3 2 1; do
    echo "${i}..."
    sleep 1
done

echo "Let's go!"

# 1. Install Homebrew if missing
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -d /opt/homebrew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d /usr/local/Homebrew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "🍺 Homebrew already installed"
fi

# 2. Install Git if missing
if ! command -v git &>/dev/null; then
    echo "🔧 Installing Git..."
    brew install git
else
    echo "🔧 Git already installed"
fi

# 3. Clone or update dotfiles repo
DOTFILES="$HOME/dotfiles"
BACKUP="$HOME/dotfiles.bak"
REPO="https://github.com/bipinbelbase/dotfiles.git"

if [ -d "$DOTFILES" ]; then
    echo "⚠️ Found existing dotfiles. Backing up to dotfiles.bak..."
    [[ -d "$BACKUP" ]] && rm -rf "$BACKUP"
    mv "$DOTFILES" "$BACKUP"
fi

echo "📥 Cloning dotfiles repository..."
git clone "$REPO" "$DOTFILES"

# 4. Install Brew packages
echo "🍻 Installing Brew packages from Brewfile..."
brew bundle --file="$HOME/dotfiles/homebrew/Brewfile" --no-lock

# 5. Install Oh My Zsh if missing (unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🌟 Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "🌟 Oh My Zsh already installed"
fi

# 6. Install Tmux Plugin Manager
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "🔌 Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "🔌 tmux plugin manager already installed"
fi

# 7. Symlink configuration files
echo "🔗 Creating symlinks for dotfiles..."
declare -A files=(
    [".zshrc"]="zsh/.zshrc"
    [".zprofile"]="zsh/.zprofile"
    [".p10k.zsh"]="zsh/.p10k.zsh"
    [".tmux.conf"]="tmux/.tmux.conf"
    [".config/nvim"]="nvim"
    ["Library/Application Support/Code/User/settings.json"]="vscode/settings.json"
    ["Library/Application Support/Code/User/keybindings.json"]="vscode/keybindings.json"
    [".config/ghostty/config"]="ghostty/config"
    ["Library/Application Support/Raycast/config.json"]="raycast/config.json"
)

for target in "${!files[@]}"; do
    source="$HOME/dotfiles/${files[$target]}"
    dest="$HOME/$target"
    dest_dir=$(dirname "$dest")

    # Ensure parent exists
    mkdir -p "$dest_dir"

    # Backup and link
    if [ -L "$dest" ]; then
        # symlink exists
        if [ "$(readlink "$dest")" == "$source" ]; then
            echo "✔ $target already linked"
            continue
        else
            echo "↻ Updating symlink: $target -> $source"
            ln -sf "$source" "$dest"
        fi
    elif [ -e "$dest" ]; then
        # real file or directory exists
        echo "⚠ Backing up existing $target to $target.bak"
        [[ -e "${dest}.bak" ]] && rm -rf "${dest}.bak"
        mv "$dest" "${dest}.bak"
        echo "🔗 Linking: $target -> $source"
        ln -s "$source" "$dest"
    else
        # missing
        echo "🔗 Linking: $target -> $source"
        ln -s "$source" "$dest"
    fi
done

# 9. Final steps
echo "✅ Setup complete!"
echo "• Run 'p10k configure' for Powerlevel10k prompt"
echo "• Press Prefix + I inside tmux to install plugins via TPM"
echo "• Restart your terminal"

exit 0
