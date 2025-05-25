#!/usr/bin/env bash
# first  run this below things
#curl -fsSL -o ~/install_mac.sh https://raw.githubusercontent.com/bipinbelbase/dotfiles/main/dotfiles/install_mac.sh && chmod +x ~/install_mac.sh && ~/install_mac.sh
set -euo pipefail
IFS=$'\n\t'

echo "🚀 Starting Mac setup..."

# Countdown for dramatic effect
for i in 3 2 1; do
    echo "$i..."
    sleep 1
done

echo "Let's go!"

# 1. Install Homebrew if missing
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

# 3. Clone or update dotfiles
DOTFILES="$HOME/dotfiles"
BACKUP="$HOME/dotfiles.bak"
REPO="https://github.com/bipinbelbase/dotfiles.git"

if [ -d "$DOTFILES" ]; then
    echo "⚠️ Existing dotfiles found. Backing up to dotfiles.bak..."
    # Remove old backup if it exists
    if [ -d "$BACKUP" ]; then
        rm -rf "$BACKUP"
    fi
    mv "$DOTFILES" "$BACKUP"
fi

echo "📥 Cloning dotfiles repo..."
git clone "$REPO" "$DOTFILES"

# 4. Install Brew packages
echo "🍻 Installing Brew packages from Brewfile..."
brew bundle --file="$HOME/dotfiles/homebrew/Brewfile" --no-lock

# 5. Symlink configuration files
echo "🔗 Creating symlinks for dotfiles..."
declare -A files=(
    [".zshrc"]="zsh/.zshrc"
    [".zprofile"]="zsh/.zprofile"
    [".p10k.zsh"]="zsh/.p10k.zsh"
    [".bashrc"]="zsh/zshrclinux"
    [".fzf.bash"]="zsh/.fzf.bash"
    [".fzf.zsh"]="zsh/.fzf.zsh"
    [".tmux.conf"]="tmux/.tmux.conf"
    ["config/nvim/init.lua"]="nvim/init.lua"
    ["Library/Application Support/Code/User/settings.json"]="vscode/settings.json"
    ["Library/Application Support/Code/User/keybindings.json"]="vscode/keybindings.json"
    [".ghostty/config"]="ghostty/config"
    ["Library/Application Support/Raycast/config.json"]="raycast/config.json"
)

for target in "${!files[@]}"; do
    source="$HOME/dotfiles/${files[$target]}"
    dest="$HOME/$target"
    dest_dir=$(dirname "$dest")

    mkdir -p "$dest_dir"
    if [ -L "$dest" ]; then
        linked=$(readlink "$dest")
        if [ "$linked" == "$source" ]; then
            echo "✔ $target already linked"
            continue
        else
            echo "↻ Updating symlink: $target -> $source"
            ln -sf "$source" "$dest"
        fi
    elif [ -e "$dest" ]; then
        echo "⚠ Backing up existing $target to $target.backup"
        mv "$dest" "$dest.backup"
        echo "🔗 Linking: $target -> $source"
        ln -s "$source" "$dest"
    else
        echo "🔗 Linking: $target -> $source"
        ln -s "$source" "$dest"
    fi
done

echo "✅ Setup complete!"

p10k configure

exit
