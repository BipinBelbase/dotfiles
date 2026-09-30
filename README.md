# Bipin's dotfiles

This repository maintains the macOS setup and is adding a separate Fedora
profile one component at a time. It is organized into small application
packages. The package layout follows the useful organizational idea from an
earlier experiment, while the actual configurations and behavior come from
the trusted root `dotfiles/` setup. The existing user `.bashrc` and
`.ideavimrc` are included as extra user-owned files because no root copies
exist.

## What's here

- `stow/`: per-application home-directory layouts for Zsh, Neovim, tmux,
  Ghostty, yabai, skhd, Bash, IdeaVim, and VS Code settings.
- `stow/fedora-bash/` and `stow/linux-tmux/`: Linux shell and tmux files,
  separate from the Mac versions.
- `packages/Brewfile`: the trusted root Mac package list.
- `packages/fedora-core.txt` and `install_fedora.sh`: Fedora's base package
  list and component-by-component installer. Existing files are backed up
  before links are replaced.
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
linked; its tasks file is retained but not linked automatically. Fedora work
is tracked in [`docs/PLANNING_FOR_LINUX.md`](docs/PLANNING_FOR_LINUX.md);
Windows remains future work.

On Fedora, run `./install_fedora.sh packages` to install the small CLI base
(sudo will ask for your password), then run `./install_fedora.sh bash`,
`./install_fedora.sh tmux`, or `./install_fedora.sh nvim` one component at a
time. The installer refuses to run on macOS.

## Safety and review

The user approved the live cutover on 2026-09-30. `~/dotfiles` on `main` is
now the maintained setup. Live configs link into `stow/`; the old checkout
is backed up outside this repository. Read
[`docs/CUTOVER_REPORT.md`](docs/CUTOVER_REPORT.md) for verification and recovery.
Do not run the full installer on this configured Mac for routine maintenance.

## Start here

Read [`docs/MIGRATION_STATUS.md`](docs/MIGRATION_STATUS.md), then
[`INSTALL_MAC.md`](INSTALL_MAC.md). Use the
[`separate-Mac checklist`](docs/NEW_MAC_CHECKLIST.md) only on a dedicated test
Mac.
