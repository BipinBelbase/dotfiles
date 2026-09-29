# tmux Reference

tmux manages terminal sessions, windows, and panes inside Ghostty.

The active configuration is:

`dotfiles2.0/stow/tmux/.tmux.conf`

The tmux prefix is:

`Ctrl + Space`

Press the prefix, release it, then press the next key.

## General settings

- Windows and panes start at number 1.
- Windows are renumbered after one is closed.
- Extended keyboard keys and focus events are enabled.
- Repeated pane movement is supported.
- Mouse support is enabled.
- Scrollback history is set to 20,000 lines.
- Terminal color support is configured for Ghostty.
- The status bar is enabled and shows the session, window name/number, and date/time.
- The active pane has a bright border; inactive panes use a dark border.

## Panes

| Shortcut | Action |
|---|---|
| `Prefix`, then `\\` | Split left/right |
| `Prefix`, then `-` | Split top/bottom |
| `Prefix`, then `H/J/K/L` | Move to the left/down/up/right pane |
| `Prefix`, then `E` | Kill all other panes, keeping the current pane |
| `Ctrl + [` | Enter vi copy mode |
| `V` in copy mode | Start a selection |
| `Y` in copy mode | Copy the selection to the macOS clipboard and exit copy mode |

tmux uses vi-style keys in copy mode.

## Windows

| Shortcut | Action |
|---|---|
| `Prefix`, then `1–9` | Jump to tmux window 1–9 |
| `Prefix`, then `P` | Previous tmux window |
| `Prefix`, then `N` | Next tmux window |

Window and pane numbering starts at 1. Windows are renumbered when one is closed.

## Sessions and projects

| Shortcut | Action |
|---|---|
| `Prefix`, then `S` | Choose a tmux session |
| `Prefix`, then `M` | Choose a tmux session |
| `Prefix`, then `F` | Open the project picker in a new tmux window |
| `Ctrl + F` | Open the project picker directly |
| `Alt + F` | Open the project picker directly |

## How the project picker works

The project picker searches your home directory with `fzf`. It skips heavy or irrelevant directories such as Library, `.local`, `.npm`, `.cache`, `.oh-my-zsh`, and repository `.git` directories.

When you choose a folder:

1. Its folder name becomes the tmux session name.
2. Dots in the name become underscores.
3. If the session does not exist, tmux creates it in that folder.
4. If the session already exists, tmux reuses it.
5. From outside tmux, it attaches to that session.
6. From inside tmux, it switches to that session.

This means you can move to a project without manually typing `cd`, creating a session, or remembering the session name.

## Other controls

| Shortcut | Action |
|---|---|
| `Prefix`, then `R` | Reload `~/.tmux.conf` |
| `Prefix`, then `O` | Open the current pane directory in Finder |
| `Prefix`, then `C-Space` | Send the tmux prefix to a nested tmux session |

## Useful mental workflow

1. Open Ghostty with `Cmd + Return`.
2. Press `Ctrl + F` and choose a project.
3. Use `Prefix`, then `\\` or `-` to split panes.
4. Use `Prefix`, then `H/J/K/L` to move around.
5. Leave the session running and return to it with `Prefix`, then `S` or `M`.

## Reloading

Inside tmux:

`Prefix`, then `R`

The tmux config is separate from yabai and skhd. Reloading tmux does not restart the window manager.
