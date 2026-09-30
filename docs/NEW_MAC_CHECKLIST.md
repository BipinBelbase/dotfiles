# Separate-Mac install checklist

Use this only on a separate test Mac. Do not use it to switch the current
Mac. Record a date and notes beside any item that fails.

## 1. Before installing

- [ ] Confirm this is the intended test Mac and identify its macOS version.
- [ ] Confirm it is Apple Silicon. The current shell and window-manager paths
      use `/opt/homebrew`; stop before installation on Intel until those paths
      are made portable.
- [ ] Clone the reviewed, committed `migration/unified-macos` branch into
      `~/dotfiles` (the installer expects that path).
- [ ] Run `git status --short --branch` and confirm the intended branch and
      clean checkout.
- [ ] Read `README.md`, `docs/MIGRATION_STATUS.md`, and
      `INSTALL_MAC.md`.
- [ ] Run `./install_mac.sh --help`.
- [ ] Run `./install_mac.sh --dry-run`; review every destination and backup
      path it prints. A dry run does not install or validate software.
- [ ] Confirm files that would be moved to `.bak.<timestamp>` are safe to
      back up. The installer preserves conflicts by moving them; it does not
      merge their contents.

## 2. Install and check each area

- [ ] Run `./install_mac.sh` on the test Mac only.
- [ ] Open a new terminal. Confirm Zsh starts, Powerlevel10k loads, and Zsh
      aliases/functions and fzf work.
- [ ] Press Ctrl+F in Zsh and confirm the project picker launches. Confirm
      `~/.local/bin/tmux-sessionizer` exists and is executable.
- [ ] Start tmux. Confirm the prefix, pane/window commands, plugins, and
      session picker match `docs/config-reference/tmux/REFERENCE.md`.
- [ ] Start Neovim. Check startup and plugin loading; use the mappings in
      `stow/nvim/.config/nvim/docs/reference-keymap-inventory.md`. Check the
      editing, LSP/formatting, debugging, and project workflows you use.
- [ ] On this test Mac, run the two existing repository checks:
      `nvim --headless -u NONE -c 'luafile tests/test_debugging.lua' -c 'qa'`
      and `python3 tests/test_window_manager.py`. These are copied from the
      trusted root tests with only their repository paths updated.
- [ ] Open Ghostty and check fonts, colors, and terminal behavior.
- [ ] Check yabai/skhd. Grant macOS Accessibility and Input Monitoring
      permissions if requested; run the included WM doctor if available.
- [ ] Open IdeaVim and check the settings you rely on.
- [ ] Optionally check VS Code preferences and manually import a Raycast
      export. VS Code tasks are retained but not automatically linked; Raycast
      exports are not automatically imported.
- [ ] Confirm the ServBay-managed `~/.bash_profile` is not targeted.
- [ ] Review symlink targets and confirm none are dangling.

## 3. If a stage fails

Read the reported failing `STEP` in the install output and inspect the machine
before retrying. The installer does not save progress or roll back completed
work. Resume from the stage that failed, after confirming its prerequisites:

| Stage | Use when |
| --- | --- |
| `homebrew` | Start the full sequence. |
| `git` | Homebrew is ready, but Git setup failed. |
| `clone` | Homebrew/Git are ready, but repository setup failed. |
| `packages` | The Brewfile installation or package pinning failed. |
| `zsh` | Oh My Zsh setup failed. |
| `tmux` | TPM or tmux plugin setup failed. |
| `links` | A link or subsequent plugin download failed; inspect backups first. |

Example: `./install_mac.sh --from=tmux`. If the error is unclear, stop and
record the full error plus the current `git status`; do not repeatedly rerun
the entire install without checking state.

## 4. Record the result

- [ ] Write pass/fail and notes for each area in a test report or this
      checklist.
- [ ] Make fixes only in the migration candidate, then transfer the reviewed
      change to the test Mac and repeat the affected checks.
- [ ] Keep the original checkout and backups until the candidate passes.
- [ ] Decide separately whether to use this configuration on another Mac.

This checklist is a plan. It is not evidence that the installer or a fresh
Mac setup has already passed.
