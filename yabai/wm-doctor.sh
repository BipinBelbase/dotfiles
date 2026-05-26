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
    socket_ok=false

    printf 'Versions: '
    "$SKHD" --version 2>/dev/null || true
    printf '          '
    "$YABAI" --version 2>/dev/null || true
    show_service skhd
    show_service yabai

    if "$YABAI" -m query --spaces --space >/dev/null 2>&1; then
        printf 'yabai socket: responsive\n'
        socket_ok=true
    else
        printf 'yabai socket: FAILED (skhd shortcuts that call yabai cannot work)\n' >&2
    fi

    if [ "$socket_ok" = false ]; then
        if [ -f "$YABAI_ERR" ] && grep -q 'could not access accessibility features' "$YABAI_ERR"; then
            printf 'Detected: yabai lost Accessibility permission. Re-enable it in System Settings > Privacy & Security > Accessibility.\n' >&2
        fi
        if [ -f "$YABAI_ERR" ] && grep -Eq 'sudo: .*password|sudo: a terminal is required' "$YABAI_ERR"; then
            printf 'Detected: scripting-addition sudo authorization may be stale. Run: %s after-upgrade\n' "$0" >&2
        fi
        if [ -f "$SKHD_ERR" ] && grep -q 'failed to connect to socket' "$SKHD_ERR"; then
            printf 'Detected: skhd received hotkeys while yabai was unavailable; skhd itself was not the failed component.\n' >&2
        fi
    elif { [ -s "$YABAI_ERR" ] || [ -s "$SKHD_ERR" ]; }; then
        printf 'Previous errors remain in /tmp logs; yabai is currently responding. Restart clears diagnosis noise from this incident.\n'
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
