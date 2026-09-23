# Yabai Space-Switching Recovery Checkpoint

Created: 2026-09-23

## Objective

Use InstantSpaceSwitcher only while yabai's macOS 27 scripting-addition/space
switching support is broken. When upstream yabai confirms a fix, restore only
the old yabai space-switching shortcuts. Preserve every other dotfiles change.

## Current machine state

- macOS: 27.0 (build 26A428)
- yabai: 7.1.25
- skhd: 0.3.9
- yabai launch service: `com.koekeishiya.yabai`
- skhd launch service: `com.koekeishiya.skhd`
- yabai scripting addition: currently not loaded
- yabai socket: currently fails to connect
- InstantSpaceSwitcher: `/Applications/InstantSpaceSwitcher.app`, version 2.0

InstantSpaceSwitcher shows its OSD/name, but its actual space change fails on
macOS 27. This is separate from the yabai problem.

## Important preservation rule

Do not reset, checkout, restore, or rewrite the whole repository. Do not touch
Neovim, Homebrew, yabai window-management, layout, focus, resize, mouse, rules,
or window-moving settings during the future recovery.

Current unrelated uncommitted files must be preserved:

- `homebrew/Brewfile`
- `nvim/lazy-lock.json`

The relevant skhd files also contain other user changes. Edit only the
space-switching portions described below.

## Changes currently made for InstantSpaceSwitcher

In both files below, direct yabai space-focus bindings are commented:

- `skhd/skhdrc`
- `dotfiles2.0/stow/skhd/.skhdrc`

Commented bindings are the direct `cmd - 1` through `cmd - 0` commands that
run `yabai -m space --focus 1` through `--focus 10`.

The active config still preserves window movement bindings:

- `cmd + shift - 1..0`: `yabai -m window --space ...`

The stow/source config preserves its `cmd + ctrl - 1..0` window movement
bindings, but they no longer append `yabai -m space --focus ...`.

Do not remove or comment the window movement bindings when restoring space
switching.

## Upstream-fix condition

Do not restore yabai space switching merely because a new version exists.
First verify all of these:

1. The official yabai changelog/release or issue explicitly indicates macOS 27
   scripting-addition/space-focus support.
2. `yabai -m query --spaces --space` succeeds.
3. `yabai -m space --focus <different-space>` actually changes the Space.
4. `~/.config/yabai/wm-doctor.sh diagnose` reports `yabai socket: responsive`.

## Recovery procedure after confirmation

1. Record a backup/diff before editing:

   ```sh
   cp skhd/skhdrc /tmp/skhdrc.before-yabai-space-recovery
   cp dotfiles2.0/stow/skhd/.skhdrc /tmp/stow-skhdrc.before-yabai-space-recovery
   git diff -- skhd/skhdrc dotfiles2.0/stow/skhd/.skhdrc
   ```

2. In both skhd files, uncomment only the direct `cmd - 1..0` yabai space
   focus bindings. Use the current yabai executable style already present in
   each file. Do not alter the surrounding bindings.

3. Keep all `cmd + shift - 1..0` window-to-space bindings unchanged.

4. Remove InstantSpaceSwitcher only after the user explicitly confirms the
   restored yabai test works. Prefer moving the app to Trash rather than
   permanently deleting it.

5. Reload/restart using the actual loaded service labels:

   ```sh
   skhd --reload
   ~/.config/yabai/wm-doctor.sh restart
   ~/.config/yabai/wm-doctor.sh diagnose
   ```

   Do not rely on `yabai --restart-service` if it targets the stale
   `com.asmvik.yabai` label; this machine uses `com.koekeishiya.yabai`.

6. Test one non-current space manually, then test all configured shortcuts.

## Final success criteria

- yabai socket reports responsive.
- `yabai -m space --focus N` changes to Space N.
- `cmd - 1..0` switches Spaces through yabai.
- `cmd + shift - 1..0` still moves windows as before.
- Window focus, layout, resize, rules, and other WM shortcuts still work.
- InstantSpaceSwitcher is removed only after the above tests pass.

## Future instruction to Codex

When the user returns and says the upstream yabai macOS 27 fix is available,
read this checkpoint first. Inspect the current diff before editing. Preserve
all unrelated modifications and change only the two skhd space-switching
sections. Ask for confirmation before removing InstantSpaceSwitcher.
