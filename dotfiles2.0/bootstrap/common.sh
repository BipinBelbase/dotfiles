#!/usr/bin/env sh
#
# common.sh -- common bootstrap tasks run on all systems prior to package installation.
#
# This script creates basic directory structures and any prerequisites that
# apply across all supported operating systems. It doesn't install
# packages—see the OS specific bootstrap scripts for that.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"

echo "[common.sh] Creating base directories in $HOME"

run_cmd mkdir -p "$HOME/.config"
run_cmd mkdir -p "$HOME/.local/bin"
run_cmd mkdir -p "$HOME/.cache"

if is_dry_run; then
  echo "[common.sh] Dry-run complete"
else
  echo "[common.sh] Base directories created"
fi
