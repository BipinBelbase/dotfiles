# My macOS Productivity Quick Reference

This is the short map. Use the detailed references for every setting and shortcut.

## Detailed references

- [Neovim reference](nvim/REFERENCE.md) — your custom keys first, inherited defaults, coding workflows, settings and complete keymap lookup.
- [Yabai reference](yabai/REFERENCE.md) — layout, window rules, macOS 27 patch, health checks, and recovery.
- [skhd reference](skhd/REFERENCE.md) — every global shortcut and the i3-style Space workflow.
- [tmux reference](tmux/REFERENCE.md) — panes, windows, sessions, project picker, and terminal workflow.

## The simple mental model

- yabai arranges windows and controls Spaces.
- skhd listens for global keyboard shortcuts and tells yabai what to do.
- tmux manages terminal panes, windows, and sessions inside Ghostty.
- Ghostty must not show the Secure Keyboard Entry lock when I want global Cmd shortcuts to work.

## The three Space shortcuts

- `Cmd + number`: go to a Space.
- `Cmd + Shift + number`: move the current window there and stay here.
- `Cmd + Ctrl + number`: move the current window there and follow it.

## The core window shortcuts

These are the main i3-style controls. The letters follow the Vim/i3 direction pattern.

| Action | Shortcut |
|---|---|
| Focus left / down / up / right | `Cmd + H/J/K/L` |
| Swap the current window | `Cmd + Shift + H/J/K/L` |
| Toggle floating | `Cmd + Shift + Space` |
| Fill this Space / restore tiled layout | `Cmd + F` |
| Minimize to Dock (macOS default) | `Cmd + M` |

`Cmd + F` is yabai zoom, not macOS Full Screen. Use the green window button for native Full Screen (a separate Space). Details: [Yabai reference](yabai/REFERENCE.md#maximize-fullscreen-and-minimize).

The default layout is BSP, similar to i3. New windows are placed as the second child. Padding and gaps are currently zero.

## tmux essentials

- Prefix: `Ctrl + Space`.
- Project picker: `Ctrl + F`.
- Move between panes: Prefix, then `H/J/K/L`.
- Split panes: Prefix, then `\\` or `-`.
- Choose a session: Prefix, then `S` or `M`.

## Recovery when something stops working

1. If the Ghostty lock icon is visible, disable **Ghostty → Secure Keyboard Entry**.
2. Check the services:

   `~/.config/yabai/wm-doctor.sh diagnose`

3. If the services are stopped, restart them:

   `~/.config/yabai/wm-doctor.sh restart`

4. Test a direct Space switch with `Cmd + 2`.
5. If only Ghostty fails, check Secure Keyboard Entry before changing yabai.

The important current result is `yabai socket: responsive`. The detailed references contain the full recovery notes and current design details.
