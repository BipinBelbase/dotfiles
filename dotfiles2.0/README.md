# dotfiles2.0

The organized successor to the root-level Mac setup. The root-level configs
remain the source of truth until the user chooses to switch. This directory is
being prepared as a self-contained Mac setup, with other operating systems as
later work.

## Start here

- [Migration map](MIGRATION_FROM_DOTFILES.md) lists where each current config
  lives in this tree and what still needs a separate machine or account.
- `docs/config-reference/` contains the shortcut and tool reference notes.
- `stow/` contains the configurations installed into the home directory.
- `packages/Brewfile` is the Mac package inventory copied from the current
  root `homebrew/Brewfile`.
- `install.sh` coordinates the work; `--step` lets you resume at one stage.

## Mac install stages

On a new Mac, install Apple's command line tools, clone the repository, and
enter the 2.0 directory:

```sh
xcode-select --install
git clone https://github.com/bipinbelbase/dotfiles.git ~/dotfiles
cd ~/dotfiles/dotfiles2.0
zsh ./install.sh --test
zsh ./install.sh --step=all
```

The installer expects to run inside this checked-out directory; it does not
clone or replace the repository for you.

If a stage fails, fix the reported cause and rerun only that stage:

```sh
zsh ./install.sh --step=bootstrap
zsh ./install.sh --step=packages
zsh ./install.sh --step=shell
zsh ./install.sh --step=link
zsh ./install.sh --step=plugins
```

Stages are safe to repeat in normal conditions. Homebrew Bundle reconciles the
package list; Stow links are preceded by conflict backups. Review the backup
directory and logs under `.logs/` if a stage stops partway through. The Mac
package stage uses the complete Brewfile, so `PROFILE` and `GROUPS` do not
filter Mac packages. The shell stage installs Oh My Zsh, and the plugin stage
sets up TPM and the configured tmux plugins. The other OS bootstrap scripts
still use package groups and need a separate migration and verification pass.

`--test` previews bootstrap and package actions and checks Stow links against
a temporary home when Stow is available. On a clean Mac without Stow it says
that link checking is deferred until packages are installed. It does not
install packages or change the real home links. It is a useful check, not
proof that Homebrew downloads or macOS permissions will succeed on a
particular computer.

## Modules

The Stow modules include Neovim, Zsh, tmux, Ghostty, Git, yabai, skhd, VS Code,
and Raycast. See the migration map for platform-specific paths and details.

The window manager requires manual macOS Accessibility and Input Monitoring
permissions. Its config also uses Apple Silicon Homebrew paths and scripting
addition setup; a new machine may require the documented repair steps.

## Recovery and versioning

- Review `git status` before and after each change. Commit coherent changes so
  they can be reverted; push commits to keep a remote copy.
- Existing conflicts are backed up under `~/.dotfiles_backup/` before linking.
- Installer logs are written under `.logs/` in this checkout.
- Git records config history, not installed app versions, credentials, app
  state, macOS permissions, or datasets.
- Never commit API keys, `.env` files, private assistant settings, or course
  datasets. Back those up separately using a private, secure method.

Do not delete the root-level setup until the migration map is reviewed, the
target tree is committed and pushed, and the user has chosen to install it on
a separate clean Mac or another explicitly approved test environment.
