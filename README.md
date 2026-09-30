# Mac dotfiles

This is a Mac-first dotfiles repository organized into small application
packages. The package layout follows the useful organizational idea from an
earlier experiment, while the actual configurations and behavior come from
the trusted root `dotfiles/` setup. The existing user `.bashrc` and
`.ideavimrc` are included as extra user-owned files because no root copies
exist.

## What's here

- `stow/`: per-application home-directory layouts for Zsh, Neovim, tmux,
  Ghostty, yabai, skhd, Bash, IdeaVim, and VS Code settings.
- `packages/Brewfile`: the trusted root Mac package list.
- `exports/raycast/`: manual-import Raycast exports.
- `install_mac.sh`: Mac installer, retaining the original designed sequence.
- `docs/`: migration status, setup instructions, and future platform notes.
- `archive/legacy-root/`: read-only snapshot of the previous root structure.
- `tests/`: the two existing root checks, with repository paths updated.

The older AI-created `dotfiles2.0` configuration and installer are not part of
the candidate. Its former package organization is only a layout reference.
The folders use a Stow-compatible shape, but `install_mac.sh` makes the links
itself; GNU Stow is not required. Bash and IdeaVim files are linked by the
installer even if you do not use those apps. VS Code settings/keybindings are
linked; its tasks file is retained but not linked automatically. Linux and
Windows remain future work.

## Safety and review

This repository is being developed in a separate worktree at
`~/dotfiles-migration` on branch `migration/unified-macos`. The normal
`~/dotfiles` checkout and current Mac links are not part of the migration.
Review `docs/MIGRATION_STATUS.md` and the Git diff before using this on a
separate Mac. Do not install this candidate on the current Mac during the
migration.

## Start here

Read [`docs/MIGRATION_STATUS.md`](docs/MIGRATION_STATUS.md), then
[`INSTALL_MAC.md`](INSTALL_MAC.md). Use the
[`separate-Mac checklist`](docs/NEW_MAC_CHECKLIST.md) only on a dedicated test
Mac.
