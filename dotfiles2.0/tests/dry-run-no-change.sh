#!/usr/bin/env sh
#
# dry-run-no-change.sh -- ensure DRY_RUN flow does not mutate HOME.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_HOME="$(mktemp -d /tmp/dotfiles2-home.XXXXXX)"
trap 'rm -rf "$TMP_HOME"' EXIT INT TERM

echo "[test][dry-run] Running full dry-run with isolated HOME=$TMP_HOME"
DRY_RUN=1 HOME="$TMP_HOME" make -C "$REPO_ROOT" all PROFILE=base GROUPS="core cli dev langs fonts"

if find "$TMP_HOME" -mindepth 1 -print -quit | grep -q .; then
  echo "[test][dry-run][error] Dry-run modified HOME unexpectedly" >&2
  find "$TMP_HOME" -mindepth 1 -maxdepth 4 -print >&2 || true
  exit 1
fi

echo "[test][dry-run] Passed (HOME unchanged)"
