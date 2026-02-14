#!/usr/bin/env sh
#
# run.sh -- wrap execution of other scripts with logging and error handling.
#
# Usage:
#   ./scripts/run.sh <command> [args...]
#
# This wrapper creates a `.logs` directory in the dotfiles repository (if it
# doesn't already exist) and captures both stdout and stderr from the
# executed command to a timestamped log file. It also echoes the command
# being run to the terminal so users can see what is happening.
#
# This mechanism is intentionally simple: it does not attempt to parse or
# interpret log output. It only records it so the user can review the
# installation steps after the fact. If the wrapped command exits with
# a non‑zero status, run.sh will exit with the same status.

set -e

# Require a command to execute.
if [ $# -eq 0 ]; then
  echo "[run.sh] No command provided" >&2
  exit 2
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$REPO_ROOT/scripts/lib.sh"

# In dry-run mode, avoid writing logs to disk and just stream output.
if is_dry_run; then
  echo "[run.sh] Executing in dry-run mode: $*"
  "$@"
  exit $?
fi

# Ensure .logs directory exists relative to repository root.
LOG_DIR="$REPO_ROOT/.logs"
mkdir -p "$LOG_DIR"

timestamp=$(date +%Y%m%d_%H%M%S)
logfile="$LOG_DIR/run_${timestamp}.log"

echo "[run.sh] Executing: $*" | tee -a "$logfile"

# Capture the wrapped command exit status explicitly so pipeline logging
# never masks command failures.
status_file="$(mktemp "$LOG_DIR/run_status_XXXXXX")"
(
  set +e
  "$@"
  echo $? > "$status_file"
) 2>&1 | tee -a "$logfile"

exit_code="$(cat "$status_file")"
rm -f "$status_file"

if [ "$exit_code" -ne 0 ]; then
  echo "[run.sh] Command failed with status $exit_code" | tee -a "$logfile"
fi

exit "$exit_code"
