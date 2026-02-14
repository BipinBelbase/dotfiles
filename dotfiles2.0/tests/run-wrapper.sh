#!/usr/bin/env sh
#
# run-wrapper.sh -- verify scripts/run.sh propagates child exit status.

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "[test][run-wrapper] Verifying successful command path"
DRY_RUN=1 sh ./scripts/run.sh sh -c 'echo ok' >/dev/null

echo "[test][run-wrapper] Verifying failing command exit propagation"
set +e
DRY_RUN=1 sh ./scripts/run.sh sh -c 'exit 7' >/dev/null
code=$?
set -e

if [ "$code" -ne 7 ]; then
  echo "[test][run-wrapper][error] Expected exit 7, got $code" >&2
  exit 1
fi

echo "[test][run-wrapper] Passed"
