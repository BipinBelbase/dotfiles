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
  - The scripting addition (SA) operation failed; check the exact load error and
    OS/tool compatibility. A working socket alone cannot establish SA health.
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
and reports relevant log clues, which may be old. It supports both old
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

## Before a macOS Upgrade

Use this checklist for macOS 27 and each later release (28, 29, 30 included).
These version numbers are not a support promise. Compatibility must be checked
for the exact OS build, CPU architecture, and installed yabai/skhd versions.
Pinning a Homebrew package does not stop Apple from changing Dock internals.

1. Keep a current Mac backup and preserve your working dotfiles, including local
   edits. Record the output below before upgrading; repeat it afterwards.
2. Read the [yabai release notes](https://github.com/asmvik/yabai/releases) for the
   intended version and OS. Check the [installation guide](https://github.com/asmvik/yabai/wiki/Installing-yabai-(latest-release))
   and [SA/SIP requirements](https://github.com/asmvik/yabai/wiki/Disabling-System-Integrity-Protection).
   A beta workaround or an open issue is not proof your installed stable release
   supports that build.
3. Check [skhd's upstream instructions](https://github.com/asmvik/skhd) separately.
   Change one component at a time, then perform the verification below. When
   compatibility is unconfirmed, postpone an optional OS upgrade on this work Mac.

Read-only baseline (Apple Silicon Homebrew paths used by this repository):

```bash
date
sw_vers
uname -m
/opt/homebrew/bin/yabai --version
/opt/homebrew/bin/skhd --version
brew list --versions yabai skhd
brew list --pinned
csrutil status
~/.config/yabai/wm-doctor.sh diagnose
```

Save a small record with: date, macOS version/build, architecture, yabai/skhd
versions, upstream support reference, and pass/fail for each verification check.
Until that record exists, this repository's combination is **unverified**.
A SIP status reading is context, not a compatibility test; review the current
upstream requirements before considering changes to SIP or boot arguments.

## Prevent Surprise Breakage

The installation script installs stable releases and runs:

```bash
brew pin skhd yabai
```

This prevents a normal `brew upgrade` from silently replacing these two
binaries. See [Homebrew's pin documentation](https://docs.brew.sh/Manpage).
It does not guarantee those binaries will work after a macOS update.

After checking upstream support, upgrade yabai intentionally:

```bash
brew unpin yabai
brew upgrade yabai
brew pin yabai
```

Run these commands one at a time and inspect each result; re-pin even if the
upgrade fails. Repair and verify yabai before a separate skhd upgrade. For skhd,
use the same unpin/upgrade/pin sequence with `skhd`, then check its permissions
and run `~/.config/yabai/wm-doctor.sh restart`.

Homebrew can change the executable path used by a LaunchAgent. If a service
still points to a removed version, follow that tool's upstream service
uninstall/start instructions; restarting a stale service definition will not
repair its path.

## Repair After Upgrade

Start with `diagnose` and the current error. Use the permissions checklist below
when a fresh error or the settings show a missing grant. Re-add the affected
executable when a stale grant is confirmed; do not reset all permissions for
every failure.

After replacing the yabai binary, run this in Terminal. It validates a staged,
hash-restricted sudoers rule before replacing the existing one, then attempts
to load the scripting addition. On load success it restarts services and
diagnoses the result. On load failure it prints diagnostics, leaves running
services alone, and returns the original load failure code:

```bash
~/.config/yabai/wm-doctor.sh after-upgrade
```

A macOS-only update does not itself change the yabai binary hash. Do not repeat
`after-upgrade` as a cure for every OS compatibility problem.

| Current evidence | Next action |
| --- | --- |
| Socket fails; new Accessibility error | Check yabai's grant, then restart and diagnose. |
| Direct yabai command works; hotkey fails | Check skhd service/grant, Secure Keyboard Entry, and the app blacklist. |
| New sudo password/authorization error after replacing yabai | Review the hash-restricted rule using `after-upgrade`. |
| SA load/injection error despite an installed rule | Keep the exact error; compare OS/build and tool version with upstream SA requirements. |
| Lock/pid-file error | Check for an already running instance; avoid launching a second daemon or deleting lock files blindly. |

Secure Keyboard Entry can prevent skhd from receiving keys. Finish password
entry and test from a normal window. This config deliberately blacklists GIMP
and VMware Fusion, so test outside those apps.

## Verification

Run the doctor, then exercise the actual operations:

```bash
~/.config/yabai/wm-doctor.sh diagnose
/opt/homebrew/bin/yabai -m query --spaces
```

With two ordinary desktops already present in Mission Control, use a disposable
window on Desktop 1 for these checks. Direct commands below change Space focus.

| Check | Expected result |
| --- | --- |
| `Cmd + Return` outside blacklisted apps | Ghostty opens; tests a shortcut that does not invoke yabai. |
| Two managed windows, then `Cmd + H/L` | Keyboard focus moves; pointer stays put with this repo's `mouse_follows_focus off`. |
| `/opt/homebrew/bin/yabai -m space --focus 2`, then `/opt/homebrew/bin/yabai -m space --focus 1` | Both direct commands succeed; tests yabai Space focus without the native fallback. |
| `Cmd + 2`, then `Cmd + 1` | Desktop switching works; may be using the fallback described below. |
| `Cmd + Shift + 2` on the disposable window | Window moves to Desktop 2; inspect it there and move it back. |
| Reconnect the external monitor | Recheck tiling and keyboard focus on both displays. |

The current `skhdrc` tries yabai Space focus first, then uses AppleScript to send
Control+number when yabai fails. Enable and verify the matching desktop shortcuts
in System Settings > Keyboard > Keyboard Shortcuts > Mission Control. Create the
desktops first; check the mapping yourself, especially Desktop 10/Control+0 and
multiple displays. The fallback also needs the relevant macOS permission for
synthesizing keys; inspect an Automation/Accessibility denial rather than
assuming the shortcut is configured correctly.

A successful `Cmd + number` is therefore **not proof SA works**. The window-move
and move-and-follow bindings have no equivalent native fallback in this config.
Native Mission Control remains a way to switch desktops while investigating;
see [Apple's Spaces guide](https://support.apple.com/guide/mac-help/work-in-multiple-spaces-mh14112/mac).

Logs can contain both old and current failures. A responsive socket proves only
that yabai answered the query. To isolate new log output, run this in another
terminal, reproduce one failure, then press Control+C:

```bash
tail -n 0 -F "/tmp/yabai_$(id -un).err.log" "/tmp/skhd_$(id -un).err.log"
```

A missing log file or no new error output is not proof the feature works.
Keep the exact command output alongside the version/build record.

## Permissions Checklist (if tiling/hotkeys still fail)

- System Settings -> Privacy & Security -> Accessibility:
  - enable `/opt/homebrew/bin/yabai`
  - enable `/opt/homebrew/bin/skhd`
- System Settings -> Privacy & Security -> Input Monitoring:
  - enable `/opt/homebrew/bin/skhd`
