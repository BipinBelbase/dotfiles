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

The older AI-created `dotfiles2.0` settings and installer were not carried
forward. Its former package organization informed the folder layout.
The folders use a Stow-compatible shape, but `install_mac.sh` makes the links
itself; GNU Stow is not required. Bash and IdeaVim files are linked by the
installer even if you do not use those apps. VS Code settings/keybindings are
optional and only linked with `--module=vscode`; its tasks file is not linked.
Linux and Windows remain future work.

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
