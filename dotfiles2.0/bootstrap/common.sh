#!/usr/bin/env sh
#
# common.sh -- common bootstrap tasks run on all systems prior to package installation.
#
# This script creates basic directory structures and any prerequisites that
# apply across all supported operating systems. It doesn't install
# packages—see the OS specific bootstrap scripts for that.

set -e

echo "[common.sh] Creating base directories in $HOME"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.cache"

echo "[common.sh] Base directories created"