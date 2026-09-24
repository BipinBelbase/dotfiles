# skhd Reference

skhd listens for global keyboard shortcuts and sends commands to yabai or opens applications.

## The Space shortcut pattern

| Shortcut | Meaning |
|---|---|
| `Cmd + 1–9`, `Cmd + 0` | Go to Space 1–10 |
| `Cmd + Shift + 1–9`, `Cmd + Shift + 0` | Move the current window to a Space and stay here |
| `Cmd + Ctrl + 1–9`, `Cmd + Ctrl + 0` | Move the current window to a Space and follow it |

This is the main i3-style workflow.

## Window focus

| Shortcut | Action |
|---|---|
| `Cmd + H` | Focus the window to the left; fall back to the previous stack/display |
| `Cmd + J` | Focus the window below |
| `Cmd + K` | Focus the window above |
| `Cmd + L` | Focus the window to the right; fall back to the next stack/display |
| `Cmd + Space` | Focus the first window |

`Cmd + Space` can conflict with macOS Spotlight. If it becomes unreliable, use the directional bindings and leave the rest unchanged.

## Window movement and layout

| Shortcut | Action |
|---|---|
| `Cmd + Shift + H/J/K/L` | Swap the current window in that direction; fall back to moving across displays |
| `Cmd + Shift + Space` | Toggle floating and place the window in a 4×4 grid |
| `Cmd + F` | Toggle yabai zoom-fullscreen |
| `Cmd + Shift + Left/Right` | Resize horizontally |
| `Cmd + Shift + Up/Down` | Resize vertically |
| `Cmd + Shift + E` | Set the current Space to BSP layout |
| `Cmd + Shift + S` | Set the current Space to stack layout |

## Applications

| Shortcut | Action |
|---|---|
| `Cmd + Return` | Open or activate Ghostty |
| `Cmd + Shift + Return` | Open or activate Zen Browser |
| `Cmd + Shift + R` | Run the yabai/skhd doctor restart and show a notification |

## skhd behavior

- VMware Fusion, VMware Fusion Tech Preview, `vmware-vmx`, and GIMP are blacklisted from skhd processing.
- This prevents those applications from interfering with the global shortcut daemon.
- The active service is `com.koekeishiya.skhd`.
- The active configuration is `~/.config/skhd/skhdrc`.

## Recovery

Run:

`~/.config/yabai/wm-doctor.sh diagnose`

If Ghostty has the Secure Keyboard Entry lock, turn it off before changing skhd.

If the service is stopped:

`~/.config/yabai/wm-doctor.sh restart`

## Currently inactive bindings

These are commented out and do not run:

- Alternative native-fullscreen binding.
- Alternative window insertion bindings.
- Old window-to-space-and-focus duplicates.
- Warp and recent-window experiments.

Keeping these inactive avoids duplicate Space backends and conflicting shortcuts.
