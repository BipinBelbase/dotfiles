# yabai and skhd: diagnose before changing the workflow

The intended setup is **Cmd+number → skhd → yabai → instant Space focus**.
`Cmd+Shift+number` moves a window without following; `Cmd+Ctrl+number` moves
and follows. `Option+[` / `Option+]` select adjacent Spaces. Preserve these.

A request to debug does not authorize replacing this workflow with native
Control shortcuts or another window manager. Explain settings changes and ask
first unless the current conversation explicitly authorizes them. Do not change
Mission Control, animations, Accessibility, SIP, or sudo permissions speculatively.
A source patch is preferable when the actual problem is a changed Dock API.

## Start with the local evidence

1. Read `AGENTS.md`, inspect `git status` and config symlinks. Active sources are
   `stow/skhd/.config/skhd/skhdrc` and `stow/yabai/.config/yabai/yabairc`.
   Keep `archive/legacy-root` frozen.
2. Run `~/.config/yabai/wm-doctor.sh report` in a normal Terminal. Restricted
   agent sandboxes may block process lists and Unix sockets; repeat the read-only
   query outside the sandbox before declaring either service dead.
3. Check `sw_vers`, `uname -m`, installed executable path, and signing requirement:
   `codesign -d -r- /opt/homebrew/bin/yabai`. Compare installed and source binaries
   with `shasum -a 256`. The version string alone cannot identify a local patch.
4. Inspect **`~/src/yabai`** before assuming the installed build is stock upstream:
   `git -C ~/src/yabai status --short` and `git -C ~/src/yabai log -3 --oneline`.
   Preserve local changes. Do not reset this checkout or blindly run a fork's
   `install-local` target.
5. Read the payload handshake with `python3 ~/.config/yabai/wm-payload-status.py`.
   This is read-only: it never injects, restarts, or changes Spaces. The doctor
   calls it automatically when Python is available. An unavailable socket and an
   injected payload with **zero capabilities** are different failure modes.
6. Compare new log output around a reproduced failure. Old log messages survive
   repairs. `loginwindow` Secure Keyboard Entry failures during login do not prove
   that input is currently blocked. Don't toggle security settings from old logs.

Both current labels are `com.asmvik.yabai` and `com.asmvik.skhd`. The doctor also
recognizes legacy `com.koekeishiya.*` labels; investigate duplicate labels rather
than installing another service.

## Separate the failing layers

- **Direct yabai focus fails:** inspect the Dock payload, local patch, current
  Dock binary and OS APIs. Editing skhd shortcuts cannot repair this layer.
- **Direct focus works, Cmd+number fails:** inspect active skhd config, service,
  input permissions, Secure Keyboard Entry, and shortcut conflicts.
- **Only move-and-follow fails:** verify the window move separately. Keep `&&`
  between moving and following, so a failed move cannot unexpectedly change focus.
- **Failure after a yabai rebuild:** check signing identity and hash-pinned sudo
  authorization; an old hash is distinct from an incompatible payload.
- **Failure after a macOS update:** compare the exact OS build and Dock hash with
  the patch's tested builds. Apple can move signatures and change selectors.

A responsive yabai socket proves communication with the daemon only. In 7.1.25,
`space --focus` can return 0 after a payload no-op or unverified gesture fallback.
Always query the actual focused Space after a command. A full capability mask
also does not replace a live test.

Space-switch tests visibly move the user's desktop. Explain them first, save the
starting Space/window IDs, and restore them in a `finally`/trap path. Use tests
already authorized in the current conversation; ask before otherwise disruptive
live changes. Do not move or close unrelated windows.

## Verified repair: macOS 27.2, build 26B123 (2026-10-27)

The user reported direct switching worked on 27.1 and failed after installing
27.2. The local checkout was `fdb6113`, an early Golden Gate compatibility patch.
The installed payload was 2.1.30 and returned `0x00`. SIP was already disabled;
the sudo hash matched. Neither restarting yabai nor reloading the old payload
fixed switching. A temporary test of yabai's gesture fallback also failed.

The installed payload already contained macOS 27 acceptance code. An earlier
conclusion based only on upstream's version gate was incomplete. The concrete
27.2 differences were:

- `dock.spaces` moved before the old `0x30000` scan start.
- `currentSpaceForDisplayUUID:` disappeared; the replacement is
  `currentSpaceForDisplay:`, taking a display ID obtained through `displayForSPID:`.
- Function signatures differ between the `arm64e` and `arm64e.x1` Dock slices.
- The old desktop-picture manager API is gone; do not invent its capabilities.

The reviewed [27.2 patch report](https://github.com/asmvik/yabai/issues/2832)
provided signatures, the new selector path and missing-display guards. It was
reviewed and built separately before approval to install. The complete applied
source patch is [patches/yabai-macos-27.2.patch](patches/yabai-macos-27.2.patch),
relative to upstream commit `dd845723416f5fe92af49fad5ebab00369e07edd`.
Additional local changes:

- Payload version **2.1.32**, forcing replacement of old 2.1.30 payloads and
  avoiding collision with other forks' 2.1.31 builds.
- macOS 27 validation requires **0x4D**: Dock spaces, add, remove and animation.
  Removed DPPM/move-Space and unused front-window hooks are not falsely required.
  Other OS versions retain their previous validation requirements.
- Build dependencies include `common.h`, `arm64_payload.m` and `x64_payload.m`,
  preventing stale generated payloads after signature or version edits.

Exact tested Dock SHA256:
`522c82e356484f3efca80f08b9720ba074a7ec8e6c06e4cf64426182032b7ece`

All four signatures matched once in each slice, within the payload scan windows:

| Target | arm64e offset | arm64e.x1 offset |
|---|---|---|
| dock.spaces | `0x2fbb8` | `0x2ef08` |
| add_space | `0x18a750` | `0x17feb4` |
| remove_space | `0x12dbcc` | `0x1265a0` |
| animation | `0x188fdc` | `0x17e788` |

Offsets are evidence for **this Dock**, not constants to reuse blindly after
another update. Static matches alone do not establish runtime compatibility.

## Installed state and evidence

- Installed binary: `/opt/homebrew/bin/yabai`, reporting `yabai-v7.1.25`.
- Signed binary SHA256:
  `6d412ac1b1f9b8f9f31e82f4bacdd3b2bd43398494171dea0cd639562b5ab3bd`.
- Stable signing identity: existing `yabai-cert`; the designated requirement
  remains identifier `com.asmvik.yabai` with the same signing certificate.
- Installed Dock payload: **2.1.32**, live capability mask **0x4D**.
- Patched source retained in `~/src/yabai`; its tracked changes are intentionally
  left reviewable. The existing install-local script/target was preserved.
- Backups: `~/dotfiles-backups/2026-10-27-space-fix/yabai-before-patch/` contains
  the original binary, payload bundle, scoped sudo rule and launch-agent plist.
- Live evidence JSONs are in the parent `2026-10-27-space-fix` backup directory.

Verified on this Mac after installation:

- Direct yabai focus to Spaces 3, 1, 10 and 2 reached the correct state; observed
  command-plus-query times were 38–59 ms (not a visual frame-time measurement).
- All ten original Cmd+number events and both Option+bracket events reached the
  expected Spaces. Cmd+Ctrl+3 moved the focused window and followed it.
- Window and focus were restored to Space 2 afterward.
- Restarting Dock automatically reloaded payload 2.1.32 through the existing
  `dock_did_restart` hook; direct switching still passed afterward.
- The six existing window-manager tests passed. These tests do not replace the
  live checks above. Creating/destroying Spaces and moving entire Spaces between
  displays were not live-tested as part of this switching repair.

Moving entire Spaces between displays remains unsupported by this patch;
**moving windows** between existing Spaces is a separate operation and passed
in the move-and-follow test. Don't describe the patch as full macOS 27 support.

## Rebuild and recovery

For this exact source baseline, a separate candidate can be reconstructed without
changing the live installation:

```sh
build_dir=$(mktemp -d /tmp/yabai-review.XXXXXX)
git -C "$HOME/src/yabai" archive dd845723416f5fe92af49fad5ebab00369e07edd | tar -x -C "$build_dir"
cd "$build_dir"
git apply "$HOME/dotfiles/docs/patches/yabai-macos-27.2.patch"
make install
```

In this upstream makefile, `make install` **only builds `bin/yabai`**; it does not
copy it to PATH. Review the makefile again if the source changes. The user's local
fork's separate `install-local` target performs consequential installation actions.

Before an approved replacement: back up binary, payload and sudo rule; verify the
candidate against the current Dock; sign with the existing certificate; verify
its designated requirement; calculate the **signed** binary's hash. Update only
the existing hash-pinned `--load-sa` rule and validate it with `visudo` before
loading. Keep root operations scoped. Never replace the rule with blanket sudo.
The existing `wm-doctor.sh after-upgrade` refreshes authorization, but does not
repair incompatible source or guarantee a matching Dock payload.

After loading, verify the actual payload version and capability mask. Reload or
restart the service only as needed; test direct focus and original shortcuts,
then the Dock-restart hook. If a candidate fails, restore the backed-up binary,
payload bundle and original sudo rule together, restart Dock and services, and
report the precise failure. Do not silently switch to a different backend.

## Native workaround was removed

During the initial incorrect approach, native shortcut IDs 118–127 and 79/81 were
enabled and skhd's Space bindings were forwarded to them. These **twelve entries
were restored exactly** from the pre-change backup, preserving unrelated settings.
The active skhd bindings and existing tests are back to their original yabai-based
versions. No native forwarding, extra switcher, or animation preference change
remains. The original native preference export is `symbolichotkeys.plist` in the
backup directory above; the twelve-entry before/after record is retained there.

Do not import that entire old preference snapshot during future repairs: the
user may have since changed unrelated shortcuts. Restore only an identified
change, after checking its current value and obtaining authorization.
