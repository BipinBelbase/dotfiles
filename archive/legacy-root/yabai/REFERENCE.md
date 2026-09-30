# Yabai Reference

Yabai is the window manager and Space controller. It uses BSP tiling, similar to i3.

## Maximize, fullscreen, and minimize

When two windows share a Space, yabai arranges them side by side (or in your current tiling layout). Focus the one you want with `Cmd + H/J/K/L`, then press `Cmd + F` to make it fill the current Space. Press `Cmd + F` again to restore the tiled layout. This is yabai's reversible `zoom-fullscreen`; it does not create a new macOS Space.

macOS Full Screen is different: use the window's green button to enter or leave native Full Screen. That moves the app into its own macOS Space. The `Alt + Shift + F` native-fullscreen binding shown commented out in `skhdrc` is disabled, so it is not a working shortcut right now.

To minimize the focused window to the Dock, use macOS's `Cmd + M`. This is the standard macOS shortcut, not a custom yabai/skhd binding. `Cmd + F` is the useful maximize/restore shortcut for keeping the app in the same Space. `Cmd + Shift + Space` is not maximize: it toggles floating and applies your configured grid placement.

See [yabai window commands](https://github.com/asmvik/yabai/wiki/Commands) for the zoom and native-fullscreen command distinction, and [Apple's Full Screen guide](https://support.apple.com/en-bw/guide/mac-help/mchl9c21d2be/mac) for the green button behavior.

## Current behavior

- Layout: BSP.
- New-window placement: second child.
- Padding: zero on every side.
- Window gap: zero.
- Window animation: disabled.
- Window shadow: disabled.
- Opacity: enabled, but both active and normal opacity are `1.0`, so windows are fully opaque.
- Mouse follows focus: off.
- macOS 27 scripting-addition patch: installed in the local Homebrew yabai binary.
- Dock restart recovery: configured through a yabai signal.

## Mouse controls

- `Option + left-drag`: move a window.
- `Option + right-drag`: resize a window.

## Applications excluded from tiling

These windows are left floating or managed by macOS:

- Music
- TV
- System Settings and System Preferences
- App Store
- System Information
- Raycast
- Stretchly
- GIMP
- VMware Fusion
- VMware Fusion Tech Preview
- `vmware-vmx`
- Windows titled `Preferences`
- Windows titled `General...`

## Important files

- Main configuration: `yabairc`
- Health and repair tool: `wm-doctor.sh`
- Human shortcut guide: `../skhd/REFERENCE.md`
- Global guide: `../QUICK_REFERENCE.md`

## Health checks

Run the normal diagnosis:

`~/.config/yabai/wm-doctor.sh diagnose`

The important success line is:

`yabai socket: responsive`

For a fuller read-only report:

`~/.config/yabai/wm-doctor.sh report`

If yabai or skhd really stops working:

`~/.config/yabai/wm-doctor.sh restart`

After replacing or upgrading the yabai binary, refresh the hash-pinned authorization and scripting addition:

`~/.config/yabai/wm-doctor.sh after-upgrade`

## macOS 27 notes

- The patched binary is `/opt/homebrew/bin/yabai`.
- The active launchd service is `com.asmvik.yabai`.
- The scripting addition must be reloaded after Dock restarts.
- The config attempts a non-interactive scripting-addition load at startup.
- Accessibility and the sudo authorization must remain valid for the patched binary.

## Recovery order

1. Check whether Ghostty shows the Secure Keyboard Entry lock.
2. If it does, use **Ghostty → Secure Keyboard Entry** to turn it off.
3. Run `wm-doctor.sh diagnose`.
4. If the socket is not responsive, run `wm-doctor.sh restart`.
5. Test `Cmd + 2` and `Cmd + Ctrl + 3`.

Do not reinstall InstantSpaceSwitcher; direct yabai Space commands are now the active backend.
