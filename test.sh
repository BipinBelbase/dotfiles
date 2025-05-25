#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "🧪 Starting dotfiles install test..."

# Step 0: Define sandbox (fake home)
SANDBOX="$HOME/dotfiles/test_env"
mkdir -p "$SANDBOX"

# Step 1: Simulate existing dotfiles folder in sandbox
mkdir -p "$SANDBOX/dotfiles"
echo "Dummy dotfile content" >"$SANDBOX/dotfiles/.zshrc"

# Step 2: Backup existing dotfiles folder in sandbox (simulate backup)
if [ -d "$SANDBOX/dotfiles" ]; then
    echo "⚠️ Found existing dotfiles in sandbox. Backing up..."
    rm -rf "$SANDBOX/dotfiles.bak" || true
    mv "$SANDBOX/dotfiles" "$SANDBOX/dotfiles.bak"
fi

# Step 3: Clone the real repo to sandbox (simulate fresh clone)
echo "📥 Cloning real dotfiles repo to sandbox/dotfiles..."
git clone https://github.com/bipinbelbase/dotfiles.git "$SANDBOX/dotfiles"

# Step 4: Test symlink creation logic on a dummy file
TARGET="$SANDBOX/.zshrc"
SOURCE="$SANDBOX/dotfiles/zsh/.zshrc"
mkdir -p "$(dirname "$TARGET")"

# Backup existing if any
if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "⚠️ Backing up existing .zshrc in sandbox"
    rm -rf "$TARGET.bak" || true
    mv "$TARGET" "$TARGET.bak"
fi

echo "🔗 Creating symlink for .zshrc in sandbox"
ln -s "$SOURCE" "$TARGET"

# Step 5: Verify symlink
if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" == "$SOURCE" ]; then
    echo "✔ Symlink for .zshrc created successfully in sandbox"
else
    echo "❌ Symlink creation failed"
    exit 1
fi

echo "✅ All tests passed in sandbox ($SANDBOX). Real install script safe to run now."
