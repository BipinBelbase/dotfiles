# Yabai + skhd Troubleshooting (macOS)

This file documents common failures and the exact fixes used in this dotfiles setup.

## Quick Symptoms and Meaning

- `cmd + 1..0` does not move the window:
  - This is expected in this config. Those keys focus spaces.
- `cannot focus space due to an error with the scripting-addition.` in skhd log:
  - Yabai scripting addition (SA) is not loaded.
- `sudo: a terminal is required` in yabai log:
  - `sudo yabai --load-sa` ran from LaunchAgent without a terminal/password prompt.

## Keybindings in This Repo

From `skhd/skhdrc`:

- `cmd - 1..0`: focus space
- `cmd + shift - 1..0`: move focused window to space
- `cmd + ctrl - 1..0`: move focused window to space and follow focus

## Why SA Fails at Startup

`yabai/yabairc` runs:

```sh
sudo /opt/homebrew/bin/yabai --load-sa
```

At login, LaunchAgent is non-interactive, so sudo cannot ask for a password.  
Fix is to allow this exact command in sudoers without password.

## Permanent Fix (One-Time Setup)

Run in Terminal:

```bash
YABAI_BIN="/opt/homebrew/bin/yabai"
HASH="$(shasum -a 256 "$YABAI_BIN" | awk '{print $1}')"

printf '%s ALL=(root) NOPASSWD: sha256:%s %s --load-sa\n' "$USER" "$HASH" "$YABAI_BIN" \
| sudo tee /private/etc/sudoers.d/yabai >/dev/null

sudo chown root:wheel /private/etc/sudoers.d/yabai
sudo chmod 440 /private/etc/sudoers.d/yabai
sudo visudo -cf /private/etc/sudoers.d/yabai
```

Then load and restart services:

```bash
sudo -n /opt/homebrew/bin/yabai --load-sa
launchctl kickstart -k gui/$(id -u)/com.koekeishiya.yabai
launchctl kickstart -k gui/$(id -u)/com.koekeishiya.skhd
```

## Verification

```bash
yabai -m query --spaces --space >/dev/null && echo "yabai OK" || echo "yabai FAIL"
tail -n 30 /tmp/yabai_${USER}.err.log
tail -n 30 /tmp/skhd_${USER}.err.log
```

Expected: no repeated scripting-addition errors.

## After `brew upgrade yabai`

When yabai binary changes, SHA256 changes. Re-run the "Permanent Fix" block to refresh sudoers hash.

## Permissions Checklist (if tiling/hotkeys still fail)

- System Settings -> Privacy & Security -> Accessibility:
  - enable `/opt/homebrew/bin/yabai`
  - enable `/opt/homebrew/bin/skhd`
- System Settings -> Privacy & Security -> Input Monitoring:
  - enable `/opt/homebrew/bin/skhd`
