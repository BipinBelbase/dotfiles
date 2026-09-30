# Migration status: Mac dotfiles

Reviewed: 2026-09-30 (Asia/Seoul)

**Historical preparation report.** The user subsequently approved the live
cutover. See [CUTOVER_REPORT.md](CUTOVER_REPORT.md) for the active paths and
checks; the candidate-only restrictions below describe the earlier phase.

This file records the separate migration candidate. It is not a claim that a
fresh Mac installation has been tested.

## Rules for this migration

- The trusted source for configuration, keymaps, and behavior is the root
  `dotfiles/` tree from the `main` checkout.
- `dotfiles2.0/` contributed an organizational idea: small per-application
  packages under `stow/`. Its settings, installer, scripts, and package lists
  are not copied into this candidate.
- All edits are in `~/dotfiles-migration`, branch `migration/unified-macos`.
  The actual `~/dotfiles` checkout remains on `main` and untouched.
- `archive/legacy-root/` is a read-only copy of the original root tree. Git tag
  `legacy-pre-unification-2026-09-30` also preserves the checkpoint.
- No installer, package manager, test, or link-changing command has been run
  on this Mac. Installation validation belongs on a separate new Mac.
- Do not version credentials, machine-generated application state, datasets,
  notebook checkpoints, or ServBay's `~/.bash_profile`.

## Observed scope and included source

| Area | Migration source and rule |
| --- | --- |
| Neovim | Root `nvim/` copied as `stow/nvim/.config/nvim/`; keep its newer lockfile and mappings. |
| Zsh and Powerlevel10k | Root `zsh/` copied to `stow/zsh/`; Homebrew and Docker paths are adjusted for this package layout and `$HOME`. |
| tmux | Root tmux config and script copied to `stow/tmux/`; the sessionizer is installed under its existing home command name. |
| Ghostty | Root `ghostty/config` copied to `stow/ghostty/.config/ghostty/config`. |
| yabai and skhd | Root folders copied into matching `.config` package paths; legacy dotfile entry points are kept as links inside each package. |
| Homebrew | Root `homebrew/Brewfile` copied to `packages/Brewfile`. |
| Bash | The user's one-line `~/.bashrc` fzf setup is copied and linked by the installer. ServBay's `~/.bash_profile` is excluded and must remain machine-managed. |
| IdeaVim | User `~/.ideavimrc` is copied and linked by the installer; using IdeaVim itself is optional. |
| VS Code | Root repository settings/keybindings are linked as in the trusted installer; tasks are retained in the package but not linked automatically. The native Mac profile differed; VS Code is not a core parity gate. |
| Raycast | Root `.rayconfig` exports kept under `exports/raycast/`; import manually. |
| Existing checks | The two root tests are copied to `tests/` with paths updated for the new package layout; they have not been run. |
| Git identity | Not included because the trusted root tree has no Git config. Set identity per machine. |
| Vim history | `~/.vim/.netrwhist` is runtime history and excluded. Experimental Vim/Neovim 2.0 folders remain only in the legacy root archive. |
| Window manager | macOS-only for this stage. Verify Accessibility/Input Monitoring permissions manually on the test Mac. |

## Current Mac links checked read-only

Checked on 2026-09-30. These are observations only; no live link has been
changed.

| Home path | Current target/state | Candidate handling |
| --- | --- | --- |
| `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh` | Link into `~/dotfiles/dotfiles2.0/stow/zsh/` | Installer backs up old links and points to the root-sourced package. |
| `~/.tmux.conf` | Link into `dotfiles2.0/stow/tmux/` | Repoint to root-sourced package. |
| `~/.config/ghostty` | Link into `dotfiles2.0/stow/ghostty/` | Repoint to root-sourced package. |
| `~/.config/nvim` | Absolute link to `~/dotfiles/nvim` | Repoint to copied root Neovim package. |
| `~/.config/yabai`, `~/.config/skhd` | Absolute links to root `yabai/` and `skhd/` | Repoint to the package layout; preserve compatibility entry points. |
| `~/.yabairc`, `~/.skhdrc` | Links through the `.config` links above | Installer backs them up and creates package links. |
| `~/.local/bin/tmux-sessionizer` | Regular executable file, not a symlink | Installer backs it up and links the root script; content and executable mode match. |
| `~/.config/Code` | Link into `dotfiles2.0/stow/vscode/.config/Code` | Not handled by the root installer. The new installer links the root settings/keybindings under `~/Library/Application Support/Code/User`; this old `.config/Code` link must be reviewed during any later cutover. |
| `~/.gitconfig` | Link into `dotfiles2.0/stow/git/` | No root-main source exists; candidate does not recreate it. Review Git aliases/identity before any later cutover. |

Raycast/OpenCode `node_modules` links are application-managed runtime links,
not dotfiles to migrate.

## Links created by the candidate installer

The installer backs up a conflicting existing destination to a unique
`.bak.<timestamp>` path, then creates these links. Directory targets are
linked as directories. This is the planned map for the test Mac:

| Home destination | Candidate source |
| --- | --- |
| `~/.zshrc` | `stow/zsh/.zshrc` |
| `~/.zprofile` | `stow/zsh/.zprofile` |
| `~/.p10k.zsh` | `stow/zsh/.p10k.zsh` |
| `~/.bashrc` | `stow/bash/.bashrc` |
| `~/.ideavimrc` | `stow/ideavim/.ideavimrc` |
| `~/.tmux.conf` | `stow/tmux/.tmux.conf` |
| `~/.local/bin/tmux-sessionizer` | `stow/tmux/.local/bin/tmux-sessionizer` |
| `~/.config/nvim` | `stow/nvim/.config/nvim` |
| `~/.config/skhd` | `stow/skhd/.config/skhd` |
| `~/.skhdrc` | `stow/skhd/.skhdrc` |
| `~/.config/yabai` | `stow/yabai/.config/yabai` |
| `~/.yabairc` | `stow/yabai/.yabairc` |
| `~/Library/Application Support/Code/User/settings.json` | `stow/vscode/Library/Application Support/Code/User/settings.json` |
| `~/Library/Application Support/Code/User/keybindings.json` | `stow/vscode/Library/Application Support/Code/User/keybindings.json` |
| `~/.config/ghostty` | `stow/ghostty/.config/ghostty` |

The installer does not link VS Code `tasks.json`, `.gitconfig`,
`~/.config/Code`, `~/.bash_profile`, or Raycast exports.

Keep the existing `dotfiles2.0/` folder until the candidate has passed its
separate-Mac trial and any current-Mac cutover is explicitly planned. If the
old folder is removed before installing/repointing the candidate, the active
Zsh, tmux, Ghostty, Code, and Git links above will dangle. The candidate
installer can repoint Zsh, tmux, and Ghostty, but it does not manage
`~/.config/Code` or `~/.gitconfig`; those two need a separate decision before
removing the old folder. Do not remove `dotfiles2.0` during the test-Mac stage.

## Known portability checks

- Zsh now detects Apple Silicon or Intel Homebrew, resolves Neovim/OpenJDK
  through Homebrew, and uses `$HOME` for Docker completions. There are no
  username-specific paths in the active packages.
- yabai, skhd, and the WM doctor still use `/opt/homebrew`; the test Mac must
  be Apple Silicon unless those commands are made portable first. Homebrew
  detection in the installer alone does not change their executable paths.
- The root config copies were compared with the trusted main tree. Zsh's
  Brewfile dump path and machine-specific paths, Ghostty's comment, and
  documentation links were adjusted for the new layout; key bindings and the
  Neovim/tmux/window-manager config bodies were not changed. `zsh -n` passed
  for the installer and Zsh files; `bash -n` passed for the sessionizer and
  yabai config; `sh -n` passed for the WM doctor; and Python syntax parsing
  passed for its existing test. None were executed as runtime tests; the
  installer has not been run.
- All 88 tracked files from the trusted main tree outside `dotfiles2.0/` were
  checked against `archive/legacy-root/`; content, symlink targets, and file
  modes match. Seventeen active Markdown files were checked; all relative file
  targets exist. These are file/document checks, not runtime tests.
- A whitespace check reports trailing spaces already present in the preserved
  installer artwork and source configs. They were left intact to preserve the
  original files. This is not a runtime test result.

## How to inspect and approve the candidate

In Terminal:

```sh
cd ~/dotfiles-migration
git status --short --branch
git diff legacy-pre-unification-2026-09-30 HEAD --stat
git diff legacy-pre-unification-2026-09-30 HEAD --no-renames
git diff
git log --oneline --decorate -8
git worktree list
```

In VS Code, use **File → Open Folder** and select `~/dotfiles-migration`.
These changes are saved in a local candidate commit. They are not installation
approval. Review the commit diff and added files before accepting the migration. This candidate is not installed into the current Mac's home
directory.

## New-Mac validation plan

1. Review the local candidate commit, then transfer a Git bundle to the test
   Mac or explicitly push the branch. No remote push has been performed.
2. On that test Mac, clone/check out this candidate into `~/dotfiles`.
3. Read `README.md` and `INSTALL_MAC.md`; confirm the test Mac has no important
   files at any installer destination or confirm the backup plan.
4. Run the installer's preview there and inspect every destination. Do not
   treat a preview as proof that software works.
5. Install on that test Mac, then check shell startup, every known Neovim
   shortcut/plugin/LSP workflow, tmux and sessionizer, Ghostty, yabai/skhd,
   Homebrew packages, IdeaVim, and optional VS Code/Raycast imports.
6. Record failures and fix only the candidate. Re-run the affected stage on
   the test Mac; do not repeat completed stages without a reason.
7. Once the checklist passes, review the candidate again, record the test
   result, and decide whether to use it on another machine.

There is currently no proof of a clean install on a separate Mac. Homebrew
downloads, macOS prompts, and window-manager permissions affect elapsed time.

## Progress

| Stage | State |
| --- | --- |
| Separate Git worktree and checkpoint | Complete |
| Read-only live-path inventory | Complete |
| Stow-style Mac package layout and legacy root archive | Complete |
| Config copies compared with main root | Complete; source copies and executable modes checked; path-only layout/portability edits documented; keymaps unchanged. |
| Installer path updates and restart options | Implemented and shell syntax checked; not executed |
| Portability review and documentation | Complete; Apple Silicon WM assumption and cutover exceptions documented |
| Separate-Mac installation and functional review | Not started |
| Candidate acceptance | Not started |

## Final installer review

- The installer resolves its own folder and requires `~/dotfiles` on an Apple
  Silicon test Mac. It never silently selects a different existing checkout or
  clones an unreviewed default branch. The `clone` stage verifies the checkout.
- All 15 link sources and the Brewfile are checked before installing anything.
  Conflicts keep unique timestamped backups.
- TPM setup remains a named stage; plugin downloads happen synchronously after
  linking, through TPM's command-line installer. Removed the five-second
  background-install termination and premature old-config reload. A plugin
  failure resumes with `--from=links`.
- The missing Oh My Zsh custom vi-mode plugin is installed at the source Mac's
  observed revision `f82c4c8f4b2bdd9c914653d8f21fbb32e7f2ea6c`. Existing plugin
  directories are retained.
- Failures report a stage and resume command. Shell startup is deferred to a
  new interactive terminal instead of sourcing interactive config inside the
  installer. Original artwork remains intact.
- These fixes were read and syntax-parsed only. Downloads, runtime behavior,
  and clean installation remain unverified until the separate-Mac checklist.
