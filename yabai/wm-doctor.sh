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
        printf 'Log clues (may be old): reproduce the failing shortcut and compare new log output before choosing a repair.\n'
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
    hash="$(shasum -a 256 "$YABAI" | awk '{print $1}')"
    printf '%s ALL=(root) NOPASSWD: sha256:%s %s --load-sa\n' "$USER_NAME" "$hash" "$YABAI" |
        sudo tee /private/etc/sudoers.d/yabai >/dev/null
    sudo chown root:wheel /private/etc/sudoers.d/yabai
    sudo chmod 440 /private/etc/sudoers.d/yabai
    sudo visudo -cf /private/etc/sudoers.d/yabai
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
