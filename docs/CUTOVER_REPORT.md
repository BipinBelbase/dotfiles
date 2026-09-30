# Live Mac cutover report

Date: 2026-09-30 (Asia/Seoul)

The user explicitly approved the live migration. The maintained repository is
`~/dotfiles` on `main`, organized into `stow/<app>` and `packages/Brewfile`.
The migration branch was deleted after its commit was merged into `main`. Its
commit and the tagged pre-migration checkpoint remain in Git history. The prior
tracked source files remain in `archive/legacy-root`.

## What changed

- Merged the reviewed migration into main without discarding the old main history.
- Resolved the README merge conflict using the reviewed migration guide, then
  updated the guide and AI instructions to describe the accepted live setup.
- Repointed the live config links below. Replaced the old `~/.local/bin` directory
  symlink with a real directory; both existing sessionizer command names remain.
- Kept native Mac VS Code settings untouched. Preserved the separate legacy Code
  directory and Git settings locally under `~/.config/dotfiles-local`.
- The full installer, package installation, plugin update, service restart, and
  permission changes were not performed during cutover. A read-only Homebrew
  Bundle check confirmed dependencies and refreshed Homebrew API cache metadata.
  Git reflog records `origin/main` updated by a push at 18:03; the user later
  confirmed the current commit is pushed.
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
| Current full `--check`                            | Passed; 14 default links match and Brewfile dependencies are satisfied             |
| Current full `--dry-run`                           | Passed; 14 links already match; no package, pin, TPM, or link changes planned       |

Neovim was checked with temporary cache/state directories and automatic missing
plugin downloads disabled for the probe. Three lockfile entries had no installed
directory (bufferline, flash, gitsigns), but none was a missing active plugin in
the loaded config. No plugins were downloaded. Bufferline and flash are explicitly
disabled. These results do not certify every lazy plugin action or LSP/debugger. The
installer preview used a temporary home and stubbed macOS identity/sleep/clear
commands; it was a dry run, not an install or proof of clean-Mac behavior. A later
sandbox audit passed: an empty-home preview planned the 14 default links; a
matching sandbox passed `--check`, and a full run with stubbed macOS/Homebrew
commands left its home byte-identical. A one-module repair backed up a conflicting
directory once and skipped it on rerun. A failed plugin step reported `links` and
succeeded after rerunning that stage. VS Code is opt-in; its module created the two
links only in the sandbox. The TPM check path was corrected after the first
per-module checks. Both sessionizer command links are managed. The current-Mac
dry-run used no-op `sleep` and `clear` helpers to avoid the installer's timing
and artwork; it did not execute install or link commands. The first Brewfile
status check refreshed Homebrew's local API metadata cache, but installed
packages remained satisfied.
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

## What is preserved now

- `archive/legacy-root/` contains the tracked pre-migration root files; its 88
  archived source files were compared byte for byte with their originals.
- Git history retains the pre-migration commit `c4ce4fb`, the migration commit,
  and the pre-migration checkpoint tag. The migration branch and separate
  legacy recovery branch are no longer present.
- The old `~/dotfiles-backups/2026-09-30-cutover/` folder and exported bundle
  were later removed. They are not available for full home-directory rollback.
- Private Git identity and the legacy Code settings remain at
  `~/.config/dotfiles-local`; those files are not tracked or included in Git.

To inspect an older tracked file without switching branches, use
`git show c4ce4fb:path/from/old/repository`. Keep a separate remote or backup
copy of the current repository before relying on it as the only recovery copy.

## Daily maintenance

Edit one source under `~/dotfiles/stow/<app>`, inspect `git diff`, and make a
focused commit. Keep `archive/legacy-root` frozen. Git history provides comparison;
there is no need to maintain a second editable dotfiles folder. The Git reflog
records a push of the migration commit; the user confirmed the latest installer
fix is pushed as well. Machine-local Git/Code settings are
not included in a Git bundle; transfer them privately if needed on another Mac.
