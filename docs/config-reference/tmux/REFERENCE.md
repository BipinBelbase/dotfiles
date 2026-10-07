# tmux Reference

tmux manages terminal sessions, windows, and panes inside Ghostty.

The active configuration is:

`stow/tmux/.tmux.conf`

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
| `Prefix`, then `\` | Split left/right |
| `Prefix`, then `-` | Split top/bottom |
| `Prefix`, then `h/j/k/l` | Move to the left/down/up/right pane |
| `Prefix`, then `e` | Kill all other panes, keeping the current pane |
| `Ctrl + [` | Enter vi copy mode |
| `v` in copy mode | Start a selection |
| `y` in copy mode | Copy the selection to the macOS clipboard and exit copy mode |

tmux uses vi-style keys in copy mode.

## Windows

| Shortcut | Action |
|---|---|
| `Prefix`, then `1–9` | Jump to tmux window 1–9 |

Window and pane numbering starts at 1. Windows are renumbered when one is closed.

## Sessions and projects

Use one session per project/repository. Windows are activities inside that project:
window 1 for code/Neovim, window 2 for AI/Codex, and window 3 for run/tests/server.
This is a suggested workflow; these windows are not created automatically.
Use panes for processes that should be visible simultaneously.

| Shortcut | Action |
|---|---|
| `Prefix`, then `Tab` | Switch to the last session used by this client; press again to toggle back |
| `Prefix`, then `n` | Next tmux session |
| `Prefix`, then `p` | Previous tmux session |
| `Prefix`, then `s` | Choose a tmux session |
| `Prefix`, then `m` | Choose a tmux session |
| `Prefix`, then `f` | Open the project picker in a new tmux window |
| `Ctrl + F` | Open the project picker directly |

`Prefix + Tab` needs a previously visited session that still exists.
`n`/`p` navigate sessions in name order, not windows or visit history.

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
| `Prefix`, then `r` | Reload `~/.tmux.conf` |
| `Prefix`, then `o` | Open the current pane directory in Finder |
| `Prefix`, then `C-Space` | Send the tmux prefix to a nested tmux session |

## Useful mental workflow

1. Open Ghostty with `Cmd + Return`.
2. Press `Ctrl + F` and choose a project.
3. Use `Prefix`, then `1`, `2`, or `3` to select an activity window.
4. Split panes with `Prefix`, then `\` or `-` when processes need to stay visible together; move with `h/j/k/l` after the prefix.
5. Choose another project with `Ctrl + F`, then use `Prefix + Tab` to toggle between the two sessions. Use `Prefix + s` or `m` to choose any session.

## Reloading

Inside tmux:

`Prefix`, then `r`, or run `tmux source-file ~/.tmux.conf`.

Verify the binding with `tmux list-keys -T prefix | grep 'Tab'`;
it should show `bind-key -T prefix Tab switch-client -l` (spacing may vary).
Manual test: session A → session B → `Prefix + Tab` → A → `Prefix + Tab` → B.

The tmux config is separate from yabai and skhd. Reloading tmux does not restart the window manager.
