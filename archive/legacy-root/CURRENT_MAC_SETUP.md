# Current Mac setup

This is the operating guide for the setup in use now. It was checked on
2026-09-29. Home-directory links and installed software can change, so confirm
them on the Mac before using these notes for a restore.

## Live configuration sources

| Home path | Current source | In this checkout |
| --- | --- | --- |
| `~/.zshrc`, `~/.zprofile` | `dotfiles2.0/stow/zsh/` | Link is live; root `zsh/` is a separate copy. |
| `~/.tmux.conf` | `dotfiles2.0/stow/tmux/` | Link is live; root `tmux/` is a separate copy. |
| `~/.gitconfig` | `dotfiles2.0/stow/git/` | Link is live. |
| `~/.config/ghostty` | `dotfiles2.0/stow/ghostty/` | Link is live; root `ghostty/` is a separate copy. |
| `~/.config/nvim` | `dotfiles/nvim/` | Current root-level config. |
| `~/.config/skhd` | `dotfiles/skhd/` | Current root-level config. |
| `~/.config/yabai` | `dotfiles/yabai/` | Current root-level config and `wm-doctor.sh`. |
| `~/.skhdrc`, `~/.yabairc` | Through `~/.config/skhd` and `~/.config/yabai` | Compatibility links. |

The word “current” describes what the Mac loads now. Some live links target
the `dotfiles2.0/stow/` subdirectory, even though that tree is not to be
reorganized as part of current-setup work. Avoid editing the root copies of
Zsh, tmux, Git, or Ghostty unless first deciding how they should become the
actual live source.

## Safe daily maintenance

1. Start in this checkout and inspect `git status` before editing.
2. Edit the source that the live symlink resolves to. For Neovim and the
   window manager, that is the root-level folder named above.
3. Review the exact diff. Save a Git commit when a coherent change works; use
   a descriptive message such as `nvim: document Python debugging workflow`.
4. Push to the existing Git remote after reviewing the commit. A commit is a
   local recovery point; a push protects it if this Mac is lost.
5. Keep a second copy of the repository and important data outside this Mac.
   GitHub does not back up untracked files, ignored data, app state, or
   installed tools.

Do not edit a duplicate config because its filename looks newer. Check the
live link first. Keep experimental changes on a branch or in a separate
commit so they can be reverted without copying files around.

## Restore/versioning model

- The repository is Git-versioned on branch `main` with remote `origin`.
  Git history tracks file changes; it does not capture the current macOS
  version, Homebrew package versions, permissions, secrets, or application
  state.
- Neovim's `nvim/lazy-lock.json` records exact plugin revisions. Mason/LSP
  tools and external programs may still change independently.
- `homebrew/Brewfile` records many desired packages, but Homebrew formulas
  generally install whatever version is available when restoring. It is a
  package list, not a full exact-version image of this Mac.
- TPM and its tmux plugins need separate installation. The root installer can
  clone TPM when explicitly requested, but does not update or pin it.
- The root installer does not link `~/.gitconfig`. On a new Mac, set your Git
  name and email separately after reviewing the current Git identity settings.
- Credentials, API keys, `.env` files, private assistant settings, and course
  datasets should not be committed. Store secrets in a password manager and
  keep data backed up separately.

For a new Mac, first install macOS command-line tools and Git, clone this
repository, review the `homebrew/Brewfile`, and inspect the live-source table
before installing packages or making links. The root installer keeps its
original full install sequence; run `./install_mac.sh --dry-run` to preview
and `./install_mac.sh` to apply it. The script has not been run or functionally
verified, so review its diff and preview before using it.

## Installer caution

`install_mac.sh` operates on this checkout's root-level config folders. If
`~/dotfiles` is already a Git checkout, it uses it in place; it will not move,
delete, or clone over it. Conflicting home paths are preserved at unique
timestamped backup paths. Read [`INSTALL_MAC.md`](INSTALL_MAC.md) and inspect
the preview before applying. No installer or package restore was run for this
audit.

The setup is macOS-first. Linux and Windows restore instructions are not
ready.
