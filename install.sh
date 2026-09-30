#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
case "$(uname -s)" in
  Darwin) exec "$repo_root/install_mac.sh" "$@" ;;
  Linux) exec "$repo_root/install_linux.sh" "$@" ;;
  *)
    printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
    exit 1
    ;;
esac
