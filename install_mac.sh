#!/usr/bin/env zsh
set -euo pipefail
IFS=$'\n\t'

# === CONFIG ===
DOTFILES="$HOME/dotfiles"
BACKUP="$HOME/dotfiles.bak"
REPO="https://github.com/bipinbelbase/dotfiles.git"
BFILE="$DOTFILES/homebrew/Brewfile"
TPM_DIR="$HOME/.tmux/plugins/tpm"
typeset -A FILES
FILES=(
    .zshrc "zsh/.zshrc"
    .zprofile "zsh/.zprofile"
    .p10k.zsh "zsh/.p10k.zsh"
    .tmux.conf "tmux/.tmux.conf"
    .config/nvim "nvim"
    "Library/Application Support/Code/User/settings.json" "vscode/settings.json"
    "Library/Application Support/Code/User/keybindings.json" "vscode/keybindings.json"
    .config/ghostty/config "ghostty/config"
)

# === FLAGS ===
DRY_RUN=false
SHOW_HELP=false

for arg in "$@"; do
    case "$arg" in
    --dry-run)
        DRY_RUN=true
        ;;
    --help | -h)
        SHOW_HELP=true
        ;;
    *)
        echo "❌ Unknown option: $arg"
        exit 1
        ;;
    esac
done

if $SHOW_HELP; then
    cat <<EOF
Usage: ./install_mac.sh [options]

Options:
  --dry-run       Show what would be done, without making any changes.
  --help, -h      Show this help message and exit.

Example:
  ./install_mac.sh --dry-run
EOF
    exit 0
fi

run() {
    if $DRY_RUN; then
        echo "🧪 [Dry Run] $*"
    else
        eval "$@"
    fi
}

echo "🚀 Starting Mac setup..."
for i in 3 2 1; do
    echo "$i..."
    sleep 1
done
echo "Let's go!"

# === STEP 1: Homebrew ===
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    if [[ -d /opt/homebrew ]]; then
        eval "$('/opt/homebrew/bin/brew' shellenv)"
    elif [[ -d /usr/local/Homebrew ]]; then
        eval "$('/usr/local/bin/brew' shellenv)"
    fi
else
    echo "🍺 Homebrew already installed"
fi

# === STEP 2: Git ===
if ! command -v git &>/dev/null; then
    echo "🔧 Installing Git..."
    run "brew install git"
else
    echo "🔧 Git already installed"
fi

# === STEP 3: Clone dotfiles ===
if [ -d "$DOTFILES" ]; then
    echo "⚠️ Found existing dotfiles. Backing up to dotfiles.bak..."
    run "rm -rf '$BACKUP'"
    run "mv '$DOTFILES' '$BACKUP'"
fi

echo "📥 Cloning dotfiles repository..."
run "git clone '$REPO' '$DOTFILES'"

# === STEP 4: Install Brew Packages ===
if [ -f "$BFILE" ]; then
    echo "🍻 Installing Brew packages from Brewfile..."
    run "brew bundle --file='$BFILE' --no-lock"
else
    echo "⚠️ Brewfile not found; skipping brew bundle"
fi

# === STEP 5: Oh My Zsh ===
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🌟 Installing Oh My Zsh..."
    run "RUNZSH=no KEEP_ZSHRC=yes sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
else
    echo "🌟 Oh My Zsh already installed"
fi


# === STEP 6: Tmux Plugin Manager ===

if command -v tmux &>/dev/null; then
    if [ ! -d "$TPM_DIR" ]; then
        echo "🔌 Installing tmux plugin manager..."
        run "git clone https://github.com/tmux-plugins/tpm '$TPM_DIR'"
    else
        echo "🔄 TPM already installed. Updating TPM..."
        run "git -C '$TPM_DIR' pull origin master"
    fi

    echo "✨ Installing or updating tmux plugins..."
    tmux start-server
    tmux new-session -d -s _tpm_install "$TPM_DIR/scripts/install_plugins.sh"
    sleep 2
    if tmux has-session -t _tpm_install 2>/dev/null; then
        tmux kill-session -t _tpm_install
    fi

    echo "🔄 Reloading tmux config..."
    tmux source-file "$HOME/.tmux.conf"
else
    echo "⚠️ tmux not found; skipping tmux plugin manager setup"
fi

# === STEP 7: Symlinks ===
echo "🔗 Creating symlinks for dotfiles..."

for target in ${(k)FILES}; do
    source="$DOTFILES/${FILES[$target]}"
    dest="$HOME/$target"
    dest_dir="$(dirname "$dest")"

    run "mkdir -p \"$dest_dir\""

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$source" ]; then
            echo "✔ $target already linked"
            continue
        else
            echo "↻ Updating symlink: $target"
            run "ln -sf \"$source\" \"$dest\""
        fi
    elif [ -e "$dest" ]; then
        echo "⚠ Backing up $target to $target.bak"
        run "rm -rf \"${dest}.bak\""
        run "mv \"$dest\" \"${dest}.bak\""
        run "ln -s \"$source\" \"$dest\""
    else
        echo "🔗 Linking: $target"
        run "ln -s \"$source\" \"$dest\""
    fi
done

# === STEP 9: Source ZSH ===
if [ -n "${ZSH_NAME:-}" ] || [ -n "${BASH_VERSION:-}" ]; then
    echo "🔄 Sourcing ~/.zshrc…"
    run "source '$HOME/.zshrc'"
else
    echo "ℹ️ Please open a new terminal or run 'source ~/.zshrc'"
fi

# === DONE ===
echo "✅ Setup complete!"
echo "• Run 'p10k configure' for Powerlevel10k prompt"
echo "• Press Prefix + I inside tmux to install plugins via TPM"
echo "🔚 All done! Please open a new terminal window (or run 'exec \$SHELL') to finalize."
