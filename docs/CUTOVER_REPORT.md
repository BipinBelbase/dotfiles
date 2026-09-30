# Live Mac cutover report

Date: 2026-09-30 (Asia/Seoul)

The user explicitly approved the live migration. The maintained repository is
`~/dotfiles` on `main`, organized into `stow/<app>` and `packages/Brewfile`.
The historical migration branch remains in Git; use one active checkout.

## What changed

- Merged the reviewed migration into main without discarding the old main history.
- Resolved the README merge conflict using the reviewed migration guide, then
  updated the guide and AI instructions to describe the accepted live setup.
- Repointed the live config links below. Replaced the old `~/.local/bin` directory
  symlink with a real directory; both existing sessionizer command names remain.
- Kept native Mac VS Code settings untouched. Preserved the separate legacy Code
  directory and Git settings locally under `~/.config/dotfiles-local`.
- No installer, package installation, plugin update, service restart, permission
  change, or remote push was performed.
- ServBay Bash profile, Vim history, Neovim data/Mason/plugins, system binaries,
  credentials, and unrelated home files remain outside this migration.

## Active links

| Home path                          | New target                                         |
| ---------------------------------- | -------------------------------------------------- |
| `~/.zshrc`                         | `~/dotfiles/stow/zsh/.zshrc`                       |
| `~/.zprofile`                      | `~/dotfiles/stow/zsh/.zprofile`                    |
| `~/.p10k.zsh`                      | `~/dotfiles/stow/zsh/.p10k.zsh`                    |
| `~/.tmux.conf`                     | `~/dotfiles/stow/tmux/.tmux.conf`                  |
| `~/.bashrc`                        | `~/dotfiles/stow/bash/.bashrc`                     |
| `~/.ideavimrc`                     | `~/dotfiles/stow/ideavim/.ideavimrc`               |
| `~/.config/nvim`                   | `~/dotfiles/stow/nvim/.config/nvim`                |
| `~/.config/skhd`                   | `~/dotfiles/stow/skhd/.config/skhd`                |
| `~/.config/yabai`                  | `~/dotfiles/stow/yabai/.config/yabai`              |
| `~/.config/ghostty`                | `~/dotfiles/stow/ghostty/.config/ghostty`          |
| `~/.skhdrc`                        | `~/dotfiles/stow/skhd/.skhdrc`                     |
| `~/.yabairc`                       | `~/dotfiles/stow/yabai/.yabairc`                   |
| `~/.gitconfig`                     | `~/.config/dotfiles-local/gitconfig`               |
| `~/.config/Code`                   | `~/.config/dotfiles-local/Code`                    |
| `~/.local/bin/tmux-sessionizer`    | `~/dotfiles/stow/tmux/.local/bin/tmux-sessionizer` |
| `~/.local/bin/tmux_sessionizer.sh` | `~/dotfiles/stow/tmux/.local/bin/tmux-sessionizer` |

All 16 links were checked for target existence and exact resolved destination.
No checked active link under home entries, `.config`, `.local/bin`, `.vim`, or
native Code settings still points into `dotfiles2.0`. Managed file sources have
a hard-link count of one. No conversion of unrelated system hard links was needed.
`~/bin`, `~/.config/bin`, `~/.vimrc`, `.bash_login`, and `.profile` were absent
in the inspected setup; the existing `.bash_profile` was preserved. The system
`/bin` and `/usr/bin` were not changed.

## Verification actually performed

| Check                                             | Result                                                                             |
| ------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Zsh config and installer syntax                   | Passed                                                                             |
| Bash sessionizer/yabai and shell WM doctor syntax | Passed                                                                             |
| Existing window-manager tests                     | 6 passed                                                                           |
| Existing Neovim debugger-mapping test             | Passed                                                                             |
| Interactive login Zsh startup                     | Passed; vim alias resolves to Homebrew Neovim, Ctrl+F widget and sessionizer found |
| Interactive Bash with existing Bash rc            | Passed; non-terminal job-control notice expected                                   |
| Neovim startup and VeryLazy loading               | Passed; Ctrl+F mapping found, LazyVim loaded                                       |
| Active Neovim plugin directories                  | None missing                                                                       |
| Separate temporary tmux server                    | Passed; Ctrl+Space prefix and Ctrl+F sessionizer binding                           |
| Window-manager read-only doctor                   | skhd/yabai services running; yabai socket responsive                               |

Neovim was checked with temporary cache/state directories and automatic missing
plugin downloads disabled for the probe. Three lockfile entries had no installed
directory (bufferline, flash, gitsigns), but none was a missing active plugin in
the loaded config. No plugins were downloaded. Bufferline and flash are explicitly
disabled. These results do not certify every lazy plugin action or LSP/debugger.
The sandbox initially blocked tmux/yabai sockets; the socket checks were repeated
with approval outside the sandbox and passed. The temporary tmux server was killed.

Neovim Lua/keymaps, tmux config/sessionizer, and WM config content is preserved
from the trusted source. Zsh differences are documented path portability changes;
the native Code settings were preserved. All 17 installer artwork blocks match
the original. The legacy archive has 88 exact source-file copies.

## What still needs manual checking

- Open a new terminal so the current shell loads the new paths; existing shells
  and open Neovim instances keep previously loaded configuration.
- Try your usual Neovim editing, LSP, formatting, debugging, and project workflows.
- Try the interactive session picker, pane/window keys, Ghostty appearance, and
  yabai/skhd shortcuts. No window was moved as part of the checks.
- The doctor does not prove scripting-addition privileges or every hotkey.
  Nonempty old WM logs were observed; reproduce any issue before repairing it.
- Use `NEW_MAC_CHECKLIST.md` on a separate Apple Silicon Mac to verify the full
  installer and clean restore. Brewfile packages are not an exact system image.

## Backup and recovery

Backup directory: `~/dotfiles-backups/2026-09-30-cutover/`

- `legacy-dotfiles/`: full old checkout files, including the original nested
  version, excluding Git internals. Do not use its AI rules for the active setup.
- `repository-before.bundle`: repository history and branches before cutover.
- `home-link-manifest.json` and `home-before/`: original home path types/targets
  and regular user config files.
- `replaced-home/`: actual original paths moved aside during link replacement.
- `local-bin-original-link`: the former directory symlink.
- `active-link-manifest.json`: applied destination-to-source map.
- Git branch `legacy-main-before-cutover-2026-09-30` preserves the former main.

Do not delete these backups while assessing daily use. A rollback should first
save any edits made since cutover, switch the checkout to the preserved legacy
branch, then restore the original home paths from the backup. Restore the old
`.local/bin` symlink as a directory entry, not by copying files through it.
Do not force-reset main or overwrite backups. Ask the next helper to read both
manifests and this report before executing a rollback.

## Daily maintenance

Edit one source under `~/dotfiles/stow/<app>`, inspect `git diff`, and make a
focused commit. Keep `archive/legacy-root` frozen. Git history provides comparison;
there is no need to maintain a second editable dotfiles folder. No remote push has
been made; review main before publishing it. Machine-local Git/Code settings are
not included in a Git bundle; transfer them privately if needed on another Mac.
