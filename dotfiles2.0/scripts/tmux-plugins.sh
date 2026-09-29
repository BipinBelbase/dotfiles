#!/usr/bin/env sh
# Install/update TPM and the plugins declared by the linked tmux config.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_PARENT="$(dirname "$TPM_DIR")"
TMUX_CONF="$HOME/.tmux.conf"

if is_dry_run; then
  echo "[tmux-plugins] [dry-run] Would install/update TPM and configured tmux plugins"
  exit 0
fi

command -v git >/dev/null 2>&1 || die "[tmux-plugins] git is required"
command -v tmux >/dev/null 2>&1 || die "[tmux-plugins] tmux is required; run the packages step first"
[ -f "$TMUX_CONF" ] || die "[tmux-plugins] $TMUX_CONF is missing; run the link step first"

mkdir -p "$TPM_PARENT"
if [ -d "$TPM_DIR" ]; then
  [ -d "$TPM_DIR/.git" ] || die "[tmux-plugins] $TPM_DIR exists but is not a Git checkout; inspect it before retrying"
  git -C "$TPM_DIR" pull --ff-only
else
  CLONE_DIR="$TPM_PARENT/.tpm-install-$$"
  [ ! -e "$CLONE_DIR" ] || die "[tmux-plugins] Temporary clone path already exists: $CLONE_DIR"
  trap 'rm -rf "$CLONE_DIR"' EXIT HUP INT TERM
  if ! git clone https://github.com/tmux-plugins/tpm "$CLONE_DIR"; then
    die "[tmux-plugins] TPM clone failed; rerun this step after checking the network"
  fi
  mv "$CLONE_DIR" "$TPM_DIR"
  trap - EXIT HUP INT TERM
fi

PLUGIN_INSTALLER="$TPM_DIR/scripts/install_plugins.sh"
[ -f "$PLUGIN_INSTALLER" ] || die "[tmux-plugins] TPM install script is missing: $PLUGIN_INSTALLER"

mkdir -p "$REPO_ROOT/.logs"
SESSION="dotfiles2-tpm-$$"
STATUS_FILE="$(mktemp "${TMPDIR:-/tmp}/dotfiles2-tpm-status.XXXXXX")"
LOG_FILE="$REPO_ROOT/.logs/tpm-install-$(date '+%Y%m%d-%H%M%S')-$$.log"
CONF="$REPO_ROOT/stow/tmux/.tmux.conf"

cleanup() {
  tmux kill-session -t "$SESSION" 2>/dev/null || true
  rm -f "$STATUS_FILE"
}
trap cleanup EXIT HUP INT TERM

tmux set-option -gu @dotfiles2_plugin_install_status 2>/dev/null || true
COMMAND="tmux source-file '$CONF' >> '$LOG_FILE' 2>&1; result_code=\$?; if [ \"\$result_code\" -eq 0 ]; then (cd '$TPM_DIR/scripts' && ./install_plugins.sh) >> '$LOG_FILE' 2>&1; result_code=\$?; fi; tmux source-file '$TMUX_CONF' >> '$LOG_FILE' 2>&1; reload_code=\$?; if [ \"\$result_code\" -eq 0 ]; then result_code=\$reload_code; fi; printf '%s\\n' \"\$result_code\" > '$STATUS_FILE'"

tmux start-server
tmux new-session -d -s "$SESSION" -c "$REPO_ROOT" "$COMMAND"

elapsed=0
while [ ! -s "$STATUS_FILE" ]; do
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    die "[tmux-plugins] Install session ended before reporting a result; inspect $LOG_FILE"
  fi
  if [ "$elapsed" -ge 300 ]; then
    die "[tmux-plugins] Timed out after 300 seconds; inspect $LOG_FILE and rerun this step"
  fi
  sleep 1
  elapsed=$((elapsed + 1))
done

result_code="$(cat "$STATUS_FILE")"
[ "$result_code" = 0 ] || die "[tmux-plugins] Plugin installation failed (exit $result_code); inspect $LOG_FILE and rerun this step"
echo "[tmux-plugins] TPM and configured plugins are ready; log: $LOG_FILE"
