# Mac install and recovery guide

The user approved the live config cutover on 2026-09-30; see
[`docs/CUTOVER_REPORT.md`](docs/CUTOVER_REPORT.md). The full installer has not
been run. Use the installation procedure below on a separate new Mac.

## Review and transfer the current setup

The maintained setup is `~/dotfiles` on `main`. Check local changes before
pushing or carrying it to a new computer:

```sh
cd ~/dotfiles
git status --short --branch
git diff --stat
git diff
```

The migration and repeat-safe installer changes are pushed to `main`. Before
transferring any later edits, review them and push the commit. The archive and
pre-migration commit remain in Git history.

On a separate Apple Silicon Mac, clone the reviewed `main` branch into
`~/dotfiles`:

```sh
git clone --branch main https://github.com/bipinbelbase/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Or transfer a Git bundle when you do not want to use GitHub for the transfer:

```sh
# On the source Mac
git -C ~/dotfiles bundle create ~/dotfiles.bundle main legacy-pre-unification-2026-09-30

# Transfer the bundle, then on the test Mac
git clone --branch main /path/to/dotfiles.bundle ~/dotfiles
```

The installer requires its reviewed checkout at `~/dotfiles`, a valid package
layout, and an Apple Silicon Mac. Start by reading `README.md`, this guide,
and `docs/NEW_MAC_CHECKLIST.md`. Run `./install_mac.sh --check` and
`./install_mac.sh --dry-run` first. The dry run reports planned actions; it
does not install or verify software. A Homebrew check may refresh Homebrew's
local metadata cache.

After reviewing those results, run `./install_mac.sh` on the separate test
Mac. Existing conflicting destinations are moved to timestamped backups.
The full installation has not yet been proven on a clean Mac. Keep the
ServBay-managed `~/.bash_profile` outside the managed paths.

## Restart after an interrupted stage

The installer can resume at a named stage. Earlier stages are skipped:

```sh
./install_mac.sh --from=packages
```

Available stages are `homebrew`, `git`, `clone`, `packages`, `zsh`, `tmux`,
and `links`. For example, if Homebrew package installation stopped, rerun
with `--from=packages`. Start at `homebrew` for a full run. A resumed stage
expects its prerequisites and earlier steps to be complete; it does not
record automatic progress or roll back changes. It reports the failing stage
and a resume command. TPM downloads run synchronously after the links stage;
if a download fails, resume with `--from=links` after fixing the cause. Review the error and state
before choosing the restart point. `brew bundle` and symlinking are designed
to tolerate reruns; review backups before repeating a link stage.

## Check or manage one app

```sh
./install_mac.sh --check
./install_mac.sh --check --module=nvim
./install_mac.sh --module=nvim
./install_mac.sh --module=wm
```

`--check` compares every default managed link and checks the Brewfile,
Neovim/tmux/Zsh commands, Oh My Zsh, its vi-mode plugin, TPM, and the configured
tmux plugin. It never installs packages, updates TPM, or changes links.
Homebrew may refresh its local metadata cache while checking packages. A
non-zero result lists the missing or mismatched items. `--check --module=NAME`
checks only that app's links. Use plain `--check` for the full prerequisite
report.

`--module=NAME` manages only that module's links; it does not install its app
or dependencies. Supported modules are `zsh`, `nvim`, `tmux`, `ghostty`,
`yabai`, `skhd`, `wm`, `bash`, `ideavim`, and `vscode`. VS Code is opt-in;
the full install preserves native Code settings. Existing conflicting
files are moved to timestamped backups; links already resolving to the
expected source are skipped. Raycast exports are imported manually.

When all configured dependencies are present, the full install skips the
package install step. If some are missing, it asks Homebrew Bundle to install
without upgrading the rest; Homebrew may still upgrade a dependency required
by a missing package. Existing pins, Oh My Zsh, its
vi-mode plugin, TPM, and matching links are preserved. TPM is not updated
automatically; pass `--update-tpm` when you deliberately want to update it.
Missing tmux plugins can be installed by the full run. Linked config changes
may still require restarting or reloading the related app.

The full install has not been run end to end on this Mac or a separate Mac.
A preview and temporary-home checks do not prove every dependency or GUI
workflow succeeds on a clean machine.

## Update an existing Mac after you push a config edit

The home links already point into `~/dotfiles`. On a Mac with this repo set
up, update the checkout first:

```sh
cd ~/dotfiles
git pull --ff-only origin main
./install_mac.sh --check
```

The pull updates the linked config files; it does not reinstall applications
or recreate links. Reload or restart an app if it reads its config only at
startup. If you added a package to `packages/Brewfile`, run the full installer
or `./install_mac.sh --from=packages`; the package check skips already present
dependencies. To repair one module's link, use `./install_mac.sh --module=nvim`
with that module's name.

Use [`docs/NEW_MAC_CHECKLIST.md`](docs/NEW_MAC_CHECKLIST.md) for the functional
review of each config and shortcut. macOS may require Accessibility or Input
Monitoring permission for yabai/skhd.

Write down every issue and fix it in the maintained `~/dotfiles` checkout.
Rerun the affected stage on the test Mac and repeat the relevant checks. Homebrew
downloads and macOS permission prompts can make the first install take from
under an hour to several hours; the exact time depends on the machine and
network.

## After the separate-Mac test

Record the pass/fail results in `docs/NEW_MAC_CHECKLIST.md`. Make fixes in the
maintained `stow/<app>` paths, commit and push them, then repeat the relevant
checks. Keep the archived source and local Git/Code settings available.

## Maintain it simply

Edit the relevant `stow/<app>` file, review `git diff`, then make one focused
commit. Keep `archive/legacy-root` as the comparison reference. Do not edit
both copies or add another nested dotfiles version. Keep secrets and local
machine overrides outside Git. Add an override only when a real machine
difference requires it; cross-platform modules can wait until that work starts.

Dependencies still need downloads and permissions. Neovim's lockfile pins
plugins, and the installer pins the source Mac's custom Zsh vi-mode revision,
but the Brewfile is a package list, not a complete version snapshot. A copied
repository cannot reproduce credentials, application state, or macOS approvals.
