#!/usr/bin/env sh
#
# lib.sh -- shared helpers for dry-run aware shell scripts.

set -e

is_truthy() {
  case "${1:-}" in
    1|true|TRUE|yes|YES|on|ON) return 0 ;;
    *) return 1 ;;
  esac
}

is_dry_run() {
  is_truthy "${DRY_RUN:-0}"
}

fmt_cmd() {
  out=""
  for arg in "$@"; do
    esc="$(printf '%s' "$arg" | sed "s/'/'\\\\''/g")"
    out="$out '$esc'"
  done
  printf '%s' "${out# }"
}

run_cmd() {
  cmd_str="$(fmt_cmd "$@")"
  if is_dry_run; then
    echo "[dry-run] $cmd_str"
    return 0
  fi

  echo "[exec] $cmd_str"
  "$@"
}

warn() {
  echo "[warn] $*" >&2
}

die() {
  echo "[error] $*" >&2
  exit 1
}
