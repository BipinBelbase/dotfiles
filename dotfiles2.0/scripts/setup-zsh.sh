#!/usr/bin/env sh
# Install Oh My Zsh when the current Zsh configuration needs it.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"

OMZ_DIR="$HOME/.oh-my-zsh"
OMZ_ENTRY="$OMZ_DIR/oh-my-zsh.sh"

if [ -f "$OMZ_ENTRY" ]; then
  echo "[setup-zsh] Oh My Zsh is already installed"
  exit 0
fi

if [ -d "$OMZ_DIR/.git" ]; then
  command -v git >/dev/null 2>&1 || die "[setup-zsh] git is required to resume the existing checkout"
  echo "[setup-zsh] Resuming the existing Oh My Zsh checkout"
  git -C "$OMZ_DIR" pull --ff-only
  [ -f "$OMZ_ENTRY" ] || die "[setup-zsh] Checkout is still incomplete: $OMZ_ENTRY is missing"
  exit 0
fi

if [ -e "$OMZ_DIR" ]; then
  die "[setup-zsh] $OMZ_DIR exists but is incomplete; inspect it before retrying."
fi

if is_dry_run; then
  echo "[setup-zsh] [dry-run] Would install Oh My Zsh without starting a new shell"
  exit 0
fi

command -v curl >/dev/null 2>&1 || die "[setup-zsh] curl is required"
command -v git >/dev/null 2>&1 || die "[setup-zsh] git is required"

RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[ -f "$OMZ_ENTRY" ] || die "[setup-zsh] Installer finished without creating $OMZ_ENTRY"
echo "[setup-zsh] Oh My Zsh is ready"
