# Migration from the current root setup

This map records the intended copy from `dotfiles/` into `dotfiles2.0/`. The
current root-level configs and `install_mac.sh` were left untouched during
this migration. The root tree remains the reference until a separate-machine
restore is approved and succeeds.

## Config mapping

| Current root source | `dotfiles2.0` target | Notes |
| --- | --- | --- |
| `nvim/` | `stow/nvim/.config/nvim/` | Full tree, including Lazy lockfile, debugging config, docs, and personal keymaps. |
| `zsh/` | `stow/zsh/` | `.zshrc`, `.zprofile`, and Powerlevel10k config. |
| `tmux/.tmux.conf` | `stow/tmux/.tmux.conf` | Current bindings and appearance. |
| `tmux/tmux_sessionizer.sh` | `stow/tmux/.local/bin/tmux-sessionizer` | Name matches the current tmux and Zsh calls. |
| `ghostty/config` | `stow/ghostty/.config/ghostty/config` | Current terminal settings. |
| `skhd/skhdrc` | `stow/skhd/.skhdrc` | Default macOS skhd config path. |
| `yabai/yabairc` | `stow/yabai/.yabairc` | Current window manager config. |
| `yabai/wm-doctor.sh` | `stow/yabai/.config/yabai/wm-doctor.sh` | Recovery helper used by the current Zsh setup. |
| `vscode/settings.json`, `keybindings.json`, `tasks.json` | `stow/vscode/Library/Application Support/Code/User/` | macOS VS Code path. Settings and keybindings are also included under `.config/Code/User/` for Linux. |
| `homebrew/Brewfile` | `packages/Brewfile` | Mac installer consumes this full manifest, including formulae, apps, VS Code extensions, npm, and Cargo entries. |
| `tests/test_debugging.lua`, `tests/test_window_manager.py` | `tests/` | Copies of current support checks. |
| `QUICK_REFERENCE.md` | `docs/config-reference/QUICK_REFERENCE.md` | Kept as a central shortcut reference. |
| `tmux/REFERENCE.md`, `skhd/REFERENCE.md`, `yabai/REFERENCE.md` | `docs/config-reference/{tmux,skhd,yabai}/REFERENCE.md` | Kept separate by tool so same-named files do not overwrite each other. |

For compatibility with both the current `.config` paths and macOS service
defaults, skhd and yabai configs are copied to both paths in their Stow
modules. The `zsh` Brew wrapper uses the location of its loaded config to find
`packages/Brewfile`, so it follows the repository if the parent folder is
renamed. The original welcome and completion artwork is copied into
`scripts/install-intro.sh` and `scripts/install-finish.sh` and runs during the
full install. The original package, shell, plugin, link, and shell-ready
banners are kept under `scripts/banners/` and shown with their matching stages.
Individual resumed stages keep their banner but skip the long intro and ending
animation.

The prior 2.0 tmux sessionizer filename is retained as a compatibility copy;
the migrated tmux config and Zsh shortcuts call `tmux-sessionizer`.

The existing Git and Raycast modules are retained because they are already in
`dotfiles2.0/`; there is no corresponding root-level Git config to replace.

## Install stages and resuming

The main commands are:

```sh
zsh ./install.sh --test
zsh ./install.sh --step=bootstrap
zsh ./install.sh --step=packages
zsh ./install.sh --step=shell
zsh ./install.sh --step=link
zsh ./install.sh --step=plugins
```

`--step=all` runs the whole workflow. If a stage fails, read its error and
`.logs/` output, address the cause, then rerun that stage. Package, shell,
link, and plugin operations are designed to be repeatable. A partially
completed stage may still have installed some packages or created some links
before stopping. Inspect the state and backups before retrying if the error
happened during linking.

On macOS, `packages/Brewfile` is the package source. `brew bundle` may install
newer package versions on a later restore because the manifest lists packages,
not a frozen Homebrew snapshot. Homebrew availability, network access,
upstream package changes, and account sign-in can still stop a restore.

## Not captured by these files

- macOS Accessibility and Input Monitoring permissions for yabai/skhd.
- yabai scripting-addition authorization, which is tied to the machine and
  installed binary.
- GitHub, npm, Cargo, Docker, and other account credentials.
- Homebrew's exact installed versions, editor state outside tracked settings,
  course datasets, model weights, virtual environments, and project secrets.
- Intel Mac path support for configs that currently expect `/opt/homebrew`.

These are machine/account setup tasks, not files to copy blindly. Follow the
window-manager recovery documentation after granting the required permissions.

## Review status

File comparisons were used to identify source/target differences and copy the
root config files into the Stow modules. The installer has not been run on
the current Mac. A clean-machine end-to-end restore has not been performed,
so the migration is not yet a guarantee of zero failures. Do not remove the
root-level setup until a separate-machine restore is approved, completed, and
reviewed.
