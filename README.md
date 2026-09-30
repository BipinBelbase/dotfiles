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

The older AI-created `dotfiles2.0` settings and installer were not carried
forward. Its former package organization informed the folder layout.
The folders use a Stow-compatible shape, but `install_mac.sh` makes the links
itself; GNU Stow is not required. Bash and IdeaVim files are linked by the
installer even if you do not use those apps. VS Code settings/keybindings are
optional on macOS and linked with `--module=vscode`; its shell-based tasks file
is not linked there. `install.sh` sends macOS to the existing Mac installer.
On Linux, it detects Fedora/RHEL, Arch, or Debian/Ubuntu, installs portable CLI
and development packages, and configures Bash, Zsh, tmux, Neovim, and IdeaVim.
It links the Linux VS Code tasks, installs the Linux Zsh and tmux plugins, and
adds Minikube plus selected JavaScript and Rust command-line tools. Debian and
Ubuntu optional packages install only when available from enabled sources;
Neovim below 0.12 is supplemented with the official user-local release.
macOS-only window tools and app settings are not installed on Linux. See
[`docs/PLANNING_FOR_LINUX.md`](docs/PLANNING_FOR_LINUX.md).

Review Linux actions with `./install.sh --dry-run`, then run `./install.sh`.
For macOS, use `./install_mac.sh --check` before repairing or extending that
setup. Windows remains future work.

## Safety and review

The user approved the live cutover on 2026-09-30. `~/dotfiles` on `main` is
the maintained setup. Live configs link into `stow/`; the prior tracked configs
remain in `archive/legacy-root`. Read
[`docs/CUTOVER_REPORT.md`](docs/CUTOVER_REPORT.md) for verification and recovery.
Use `./install_mac.sh --check` before a full rerun. A green check means the
managed setup is already present; Homebrew may refresh its local metadata cache.

## Start here

Use `./install_mac.sh --check` for a status report. Use
`./install_mac.sh --module=nvim` to link one app. When the check is fully
green, a full rerun skips matching links and installed packages. It also
preserves native VS Code settings unless you explicitly select that module.
TPM updates are opt-in. See [`INSTALL_MAC.md`](INSTALL_MAC.md) for details.

On another configured Mac, `git pull --ff-only origin main` updates configs
through the existing symbolic links; reload apps as needed. Run the installer
when adding packages or repairing links.

Read [`docs/MIGRATION_STATUS.md`](docs/MIGRATION_STATUS.md), then
[`INSTALL_MAC.md`](INSTALL_MAC.md). Use the
[`separate-Mac checklist`](docs/NEW_MAC_CHECKLIST.md) only on a dedicated test
Mac.
