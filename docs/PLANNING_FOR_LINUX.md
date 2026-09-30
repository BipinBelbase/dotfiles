# Cross-platform setup

The repository has one entry point: `./install.sh`. On macOS it runs the
existing `install_mac.sh` unchanged. On Linux it detects a Fedora/RHEL,
Arch-family, or Debian/Ubuntu-family system and uses that family's package map.
Unknown Linux families stop with a clear message rather than running the Mac
installer.

The Linux setup installs the portable CLI and development tools listed in
`packages/linux/`, then links Bash, Zsh, tmux, Neovim, IdeaVim, VS Code, and the
portable Ghostty settings. It adds Oh My Zsh, Powerlevel10k, and TPM when absent, installs
the configured tmux plugins, and selects Zsh as the login shell when the system
allows it. Existing paths are moved to timestamped backups before links replace
them. A `--dry-run` previews the package and link actions.

It also installs Minikube's user-local binary, selected npm command-line tools,
and Rustlings when their runtimes are available. Minikube does not create or
start a cluster; a container runtime such as Podman must be configured first.

Package maps use each package manager's names. Debian and Ubuntu optional
packages are checked against enabled APT sources and skipped when unavailable.
Neovim packages can lag behind plugin requirements, so the installer checks
the installed version and uses the official Linux release archive in
`~/.local/opt` when it is below 0.12. Fedora and Arch still use their native
package for the base install. Run `./install_linux.sh --nvim-only` to apply
that version check without reinstalling the rest of the Linux profile.

## Current Fedora machine

- Fedora 43 KDE Plasma on Wayland. The installer completed, and `/usr/bin/zsh`
  is now the account's login shell; open a new session (log out and back in)
  for the desktop session to use it.
- `~/.bashrc` links to `stow/fedora-bash/.bashrc`; the original was preserved
  at `~/.bashrc.before-dotfiles-20260930-185004`.
- `~/.tmux.conf`, the Linux tmux helpers under `~/.local/bin`, and
  `~/.config/nvim` link into this repository. The Neovim configuration itself
  is shared with macOS; `~/.local/bin/open` supplies its Linux HTML runner.
- The Fedora package set, JetBrainsMono Nerd Font, Minikube, npm tools,
  Rustlings, Oh My Zsh, Powerlevel10k, TPM, and the configured tmux plugin are
  installed. Podman is installed; Minikube has not created a cluster.
- The Fedora Neovim package was 0.11.6, below this profile's plugin requirement.
  The installer now uses the official user-local release when Neovim is older
  than 0.12; this machine runs 0.12.5 at `~/.local/opt/nvim` via
  `~/.local/bin/nvim`. First-run plugins and 32 treesitter parsers installed,
  Neovim starts headlessly, and the configured Mason tools are present.
- Fedora repositories did not provide optional `ghostty`, `code`, or `lazygit`;
  their configs may be linked even though those applications were skipped.
- Bash and Zsh syntax checks, interactive Zsh startup, tmux config startup,
  Neovim startup, and `git diff --check` passed. Arch and Debian/Ubuntu remain
  untested on their own systems.

To apply the complete setup on a fresh or existing supported Linux checkout,
run `./install.sh` and authenticate when sudo asks. To inspect first, run
`./install.sh --dry-run`. On Arch, use a current package database and a normal
user account with sudo access.

## Platform-specific applications

yabai, skhd, Raycast, and Karabiner are macOS-only and are never installed by
the Linux path. KDE or another desktop/window manager retains its own shortcut
settings. Ghostty, GIMP, and VS Code are installed only where packages are
available in enabled repositories; their settings use each Linux editor's
configuration path. Docker Desktop is also
macOS-only; this installer does not silently replace it with a Linux Docker
daemon.

The package lists cover the portable command-line and development tools from
the Mac Brewfile where distro packages are available. They do not install
unrelated desktops or change the system-wide package set beyond those named
packages. Arch support is package-mapped but still needs a real Arch run before
being called verified; Debian and Ubuntu variants also need on-machine startup
checks after installation.
