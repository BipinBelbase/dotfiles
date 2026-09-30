# Bipin's dotfiles

This repository supports macOS and Linux with platform-specific profiles. It
is organized into small application packages. The package layout follows the useful organizational idea from an
earlier experiment, while the actual configurations and behavior come from
the trusted root `dotfiles/` setup. The existing user `.bashrc` and
`.ideavimrc` are included as extra user-owned files because no root copies
exist.

## What's here

- `stow/`: per-application home-directory layouts for Zsh, Neovim, tmux,
  Ghostty, yabai, skhd, Bash, IdeaVim, and VS Code settings.
- `stow/fedora-bash/`, `stow/linux-zsh/`, `stow/linux-tmux/`, and
  `stow/linux-ghostty/`: Linux configs separate from their Mac versions.
- `packages/Brewfile`: the trusted root Mac package list.
- `packages/linux/`: Fedora, Arch, and Debian/Ubuntu package-name maps.
- `install.sh`: one entry point that detects macOS or a supported Linux family.
  Linux setup backs up existing config paths before linking.
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
linked, as is the VS Code tasks file. On macOS,
`install.sh` runs the existing Mac installer. On Linux, it detects Fedora/RHEL,
Arch, or Debian/Ubuntu, installs portable CLI and development packages, and
configures Bash, Zsh, tmux, Neovim, and IdeaVim. It installs the Linux Zsh and
tmux plugins. Debian/Ubuntu releases receive optional packages only when they
exist in enabled APT sources; old Neovim packages are supplemented with the
official user-local release. Minikube and selected JavaScript and Rust command-
line tools are installed for the current user. macOS-only window tools and app settings are not
installed on Linux. See [`docs/PLANNING_FOR_LINUX.md`](docs/PLANNING_FOR_LINUX.md).

Review actions with `./install.sh --dry-run`, then run `./install.sh` from this
checkout and enter your sudo password when prompted. Windows remains future
work.

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
