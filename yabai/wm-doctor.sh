#!/bin/sh

set -eu

YABAI=/opt/homebrew/bin/yabai
SKHD=/opt/homebrew/bin/skhd
UID_NUMBER="$(id -u)"
USER_NAME="$(id -un)"
YABAI_ERR="/tmp/yabai_${USER_NAME}.err.log"
SKHD_ERR="/tmp/skhd_${USER_NAME}.err.log"

loaded_label() {
    app="$1"
    for label in "com.asmvik.${app}" "com.koekeishiya.${app}"; do
        if launchctl print "gui/${UID_NUMBER}/${label}" >/dev/null 2>&1; then
            printf '%s\n' "$label"
            return 0
        fi
    done
    return 1
}

show_service() {
    app="$1"
    label="$(loaded_label "$app" 2>/dev/null || true)"
    if [ -z "$label" ]; then
        printf '%s service: not loaded\n' "$app"
        return
    fi
    state="$(launchctl print "gui/${UID_NUMBER}/${label}" 2>/dev/null | awk -F'= ' '/state =/ { print $2; exit }')"
    printf '%s service: %s (%s)\n' "$app" "$state" "$label"
}

diagnose() {
    printf 'Versions: '
    "$SKHD" --version 2>/dev/null || true
    printf '          '
    "$YABAI" --version 2>/dev/null || true
    show_service skhd
    show_service yabai

    if "$YABAI" -m query --spaces --space >/dev/null 2>&1; then
        printf 'yabai socket: responsive\n'
    else
        printf 'yabai socket: FAILED (skhd shortcuts that call yabai cannot work)\n' >&2
    fi

    printf 'Scripting addition and hotkey operation: not verified by the socket query.\n'

    # Logs can outlive a failure; a responsive socket does not prove SA works.
    if [ -s "$YABAI_ERR" ] || [ -s "$SKHD_ERR" ]; then
        printf 'Non-empty log files found (may be old); reproduce the failing shortcut and compare new log output before choosing a repair.\n'
    fi
    if [ -f "$YABAI_ERR" ] && grep -q 'could not access accessibility features' "$YABAI_ERR"; then
        printf 'Log clue: yabai could not access Accessibility features. If this recurs, check its Accessibility grant in System Settings.\n' >&2
    fi
    if [ -f "$YABAI_ERR" ] && grep -Eq 'sudo: .*password|sudo: a terminal is required' "$YABAI_ERR"; then
        printf 'Log clue: sudo authorization failed. If this recurs after replacing yabai, review: %s after-upgrade\n' "$0" >&2
    fi
    if { [ -f "$YABAI_ERR" ] && grep -Eq 'scripting[ -]addition|scripting addition not loaded' "$YABAI_ERR"; } ||
       { [ -f "$SKHD_ERR" ] && grep -Eq 'scripting[ -]addition|scripting addition not loaded' "$SKHD_ERR"; }; then
        printf 'Log clue: scripting-addition messages found. Space switching can fail while the socket responds; inspect the exact error before changing sudoers or permissions.\n' >&2
    fi
    if [ -f "$SKHD_ERR" ] && grep -q 'failed to connect to socket' "$SKHD_ERR"; then
        printf 'Log clue: a command logged by skhd could not connect to yabai. This does not establish current hotkey health.\n' >&2
    fi
}

restart_service() {
    app="$1"
    label="$(loaded_label "$app" 2>/dev/null || true)"
    if [ -n "$label" ]; then
        launchctl kickstart -k "gui/${UID_NUMBER}/${label}"
    else
        "/opt/homebrew/bin/${app}" --start-service
    fi
}

restart() {
    restart_service yabai
    sleep 1
    restart_service skhd
    sleep 1
    diagnose
}

after_upgrade() {
    # Keep shasum's exit status; a pipeline through awk could hide failure.
    hash_output="$(shasum -a 256 "$YABAI")"
    hash="${hash_output%% *}"
    case "$hash" in
        ''|*[!0-9a-fA-F]*)
            printf 'Invalid yabai SHA256; sudoers was not changed.\n' >&2
            return 1
            ;;
    esac
    if [ "${#hash}" -ne 64 ]; then
        printf 'Invalid yabai SHA256 length; sudoers was not changed.\n' >&2
        return 1
    fi

    # Stage on the same filesystem so rename replaces the rule atomically.
    # The dotted staging directory is ignored by sudoers includedir.
    sudo /bin/sh -eu -c '
        staging_dir="$(mktemp -d /private/etc/sudoers.d/.yabai.XXXXXX)"
        trap '\''rm -rf "$staging_dir"'\'' 0
        trap '\''exit 1'\'' HUP INT TERM
        candidate="$staging_dir/yabai"

        printf "%s ALL=(root) NOPASSWD: sha256:%s %s --load-sa\n" "$1" "$2" "$3" > "$candidate"
        chown root:wheel "$candidate"
        chmod 440 "$candidate"
        visudo -cf "$candidate"
        mv -f "$candidate" /private/etc/sudoers.d/yabai
    ' sh "$USER_NAME" "$hash" "$YABAI"
    sudo -n "$YABAI" --load-sa
    restart
}

case "${1:-diagnose}" in
    diagnose)
        diagnose
        ;;
    restart)
        restart
        ;;
    after-upgrade)
        after_upgrade
        ;;
    *)
        printf 'Usage: %s [diagnose|restart|after-upgrade]\n' "$0" >&2
        exit 2
        ;;
esac
