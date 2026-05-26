# Yabai + skhd Troubleshooting (macOS)

This file documents common failures and the exact fixes used in this dotfiles setup.

## Quick Symptoms and Meaning

- All `cmd` window-manager shortcuts appear dead, while `skhd` log contains
  `yabai-msg: failed to connect to socket..`:
  - `skhd` received the shortcuts. `yabai` is not responsive; check its log.
- `yabai: could not access accessibility features! abort..` in yabai log:
  - macOS no longer allows the installed yabai executable under Accessibility,
    commonly because Homebrew replaced the binary during an upgrade.
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

## Fast Diagnosis

Run:

```bash
~/.config/yabai/wm-doctor.sh diagnose
```

This reports the loaded service labels, checks whether the yabai socket answers,
and recognizes the two failures above. It supports both old
`com.koekeishiya.*` and newer `com.asmvik.*` service labels.

## Why Failures Happen After Upgrade

macOS privacy grants apply to the executable it approved. Replacing an
ad-hoc-signed `yabai` or `skhd` binary can invalidate its Accessibility or
Input Monitoring grant. A dotfile cannot grant these protected permissions
again.

`yabai/yabairc` runs:

```sh
sudo -n /opt/homebrew/bin/yabai --load-sa
```

At login, LaunchAgent is non-interactive, so sudo cannot ask for a password.
The `-n` option makes the failure immediate and visible in the log.
The permitted sudoers command contains the binary hash, so replacing `yabai`
also requires updating that rule.

## Prevent Surprise Breakage

The installation script installs stable releases and runs:

```bash
brew pin skhd yabai
```

This prevents a normal `brew upgrade` from silently replacing these two
binaries. Upgrade them intentionally when needed:

```bash
brew unpin skhd yabai
brew upgrade skhd yabai
brew pin skhd yabai
```

An intentional upgrade still requires the repair below.

## Repair After Upgrade

First, in System Settings -> Privacy & Security:

- Under Accessibility, remove/re-add or toggle on `/opt/homebrew/bin/yabai`
  and `/opt/homebrew/bin/skhd`.
- Under Input Monitoring, remove/re-add or toggle on `/opt/homebrew/bin/skhd`.

Then run in Terminal. It refreshes the hash-restricted sudoers entry, loads
the scripting addition, restarts the installed service labels, and diagnoses
the result:

```bash
~/.config/yabai/wm-doctor.sh after-upgrade
```

## Verification

```bash
~/.config/yabai/wm-doctor.sh diagnose
```

Expected: `yabai socket: responsive`.

Logs under `/tmp` persist old failures until the services recreate or truncate
them. If the doctor reports a responsive socket, prior permission/socket
messages are history rather than proof of a current failure.

## Permissions Checklist (if tiling/hotkeys still fail)

- System Settings -> Privacy & Security -> Accessibility:
  - enable `/opt/homebrew/bin/yabai`
  - enable `/opt/homebrew/bin/skhd`
- System Settings -> Privacy & Security -> Input Monitoring:
  - enable `/opt/homebrew/bin/skhd`
