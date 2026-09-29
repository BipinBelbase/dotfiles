# Bipin's dotfiles

This repository tracks the Mac development setup. The current Neovim and
window-manager configs live in the root-level `nvim/`, `skhd/`, and `yabai/`
folders. The live Mac setup is not fully sourced from one folder yet: shell,
tmux, Git, and Ghostty links currently target files under `dotfiles2.0/stow/`.

Start with [CURRENT_MAC_SETUP.md](CURRENT_MAC_SETUP.md) before installing,
moving, or relinking anything. It records the live links, safe maintenance
workflow, and known restore limitations. For a new Mac, follow
[INSTALL_MAC.md](INSTALL_MAC.md). Treat `dotfiles2.0/` as a separate
future reference; do not edit or install it as part of maintenance of the
current setup.

## Main current configs

- `nvim/` — active Neovim/LazyVim configuration and shortcut reference.
- `skhd/` and `yabai/` — active keyboard shortcuts, window management, and
  `wm-doctor.sh` recovery helper.
- `tmux/`, `zsh/`, `ghostty/`, `homebrew/` — root-level configs and package
  manifest; check the live-link inventory because some current links still
  point elsewhere.

Linux and Windows are later goals. macOS is the system to keep reliable first.
