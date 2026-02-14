#!/usr/bin/env sh
#
# doctor.sh -- repository validation checks.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

fail=0

info() { echo "[doctor] $*"; }
warn() { echo "[doctor][warn] $*" >&2; }
err()  { echo "[doctor][error] $*" >&2; fail=1; }

require_file() {
  path="$1"
  if [ ! -f "$path" ]; then
    err "Missing required file: $path"
  fi
}

check_sh_syntax() {
  file="$1"
  if ! sh -n "$file"; then
    err "Shell syntax invalid: $file"
  fi
}

check_map_file() {
  map_file="$1"

  awk '
    /^[[:space:]]*($|#)/ { next }
    index($0, "=") == 0 {
      printf("[doctor][error] %s:%d missing '\''='\''\n", FILENAME, NR) > "/dev/stderr"
      bad=1
      next
    }
    {
      key=$0
      sub(/[[:space:]]*=.*/, "", key)
      if (key ~ /^[[:space:]]*$/) {
        printf("[doctor][error] %s:%d empty key\n", FILENAME, NR) > "/dev/stderr"
        bad=1
      }
    }
    END { exit bad }
  ' "$map_file" || fail=1

  dupes="$(awk -F= '
    /^[[:space:]]*($|#)/ { next }
    {
      key=$1
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
      if (key != "") count[key]++
    }
    END {
      for (k in count) if (count[k] > 1) print k
    }
  ' "$map_file")"

  if [ -n "$dupes" ]; then
    err "Duplicate keys in $map_file: $(printf '%s' "$dupes" | tr '\n' ' ')"
  fi
}

has_map_key() {
  pkg="$1"
  map_file="$2"
  awk -F= -v key="$pkg" '
    /^[[:space:]]*($|#)/ { next }
    $1 == key { found=1; exit }
    END { exit(found ? 0 : 1) }
  ' "$map_file"
}

info "Checking required files"
require_file "Makefile"
require_file "install.sh"
require_file "scripts/detect-os.sh"
require_file "scripts/run.sh"
require_file "scripts/backup.sh"
require_file "scripts/link.sh"

info "Checking shell syntax"
zsh -n "install.sh" || err "zsh syntax invalid: install.sh"
for f in scripts/*.sh bootstrap/*.sh; do
  check_sh_syntax "$f"
done

info "Checking package map format"
for map in packages/os/*.map; do
  check_map_file "$map"
done

info "Checking group package coverage (warnings only)"
for group_file in packages/groups/*.txt; do
  while IFS= read -r pkg; do
    case "$pkg" in
      ""|\#*) continue ;;
    esac
    for map in packages/os/*.map; do
      if ! has_map_key "$pkg" "$map"; then
        warn "$pkg from $(basename "$group_file") not mapped in $(basename "$map") (falls back to same name)"
      fi
    done
  done < "$group_file"
done

if [ "$fail" -ne 0 ]; then
  info "Doctor checks failed"
  exit 1
fi

info "Doctor checks passed"
