# Mac install and recovery guide

The user approved the live config cutover on 2026-09-30; see
[`docs/CUTOVER_REPORT.md`](docs/CUTOVER_REPORT.md). The full installer has not
been run. Use the installation procedure below on a separate new Mac.

## Review the working tree

The accepted setup lives in `~/dotfiles` on `main`. In Terminal:

```sh
cd ~/dotfiles
git status --short --branch
git diff legacy-pre-unification-2026-09-30 HEAD --stat
git diff legacy-pre-unification-2026-09-30 HEAD --no-renames
git diff
```

You can also open that folder in VS Code and review each changed file. `git
status` shows changed, added, and removed files. Git may label identical
content as a rename from `dotfiles2.0`; `git diff legacy-pre-unification-2026-09-30 HEAD --no-renames` shows
the recorded removals and new package files without that similarity guess.
The candidate is saved as a local Git commit. Saving a commit is a review
checkpoint; it does not approve installation. No remote push or full-installer run
has been performed. The live config cutover is recorded separately. `archive/legacy-root/` and the
`legacy-pre-unification-2026-09-30` tag preserve the previous setup.

## First installation on a separate Mac

1. Review this guide, `README.md`, `docs/MIGRATION_STATUS.md`, and the full
   candidate diff.
2. Review the committed candidate. Transfer it with a Git bundle (below),
   or explicitly publish the branch yourself after reviewing it:

   ```sh
   git -C ~/dotfiles push origin main
   ```

   No push has been made for you.
3. On the test Mac, make sure `~/dotfiles` does not contain anything you need,
   then clone the reviewed branch there:

   ```sh
   git clone --branch main \
     https://github.com/bipinbelbase/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

   If you do not want to push to GitHub, create a bundle,
   transfer it to the test Mac, and clone from that file:

   ```sh
   # On this Mac, create a portable copy of the local commit
   git -C ~/dotfiles bundle create \
     ~/dotfiles-current.bundle main

   # On the test Mac, after transferring the bundle
   git clone --branch main \
     /path/to/dotfiles-current.bundle ~/dotfiles
   ```

   The installer requires its own reviewed checkout at `~/dotfiles`, a valid
   package layout, and an Apple Silicon Mac before any installation begins.
4. Run `./install_mac.sh --help` to see available options.
5. Run `./install_mac.sh --dry-run` on the test Mac and inspect each target
   and backup path it reports. A dry run does not prove the tools work.
6. After your review, run `./install_mac.sh` on the test Mac. The install may
   install Homebrew packages, Oh My Zsh, TPM and tmux plugins, and create home
   symlinks. Existing conflicting destinations are moved to a unique backup
   name before linking.

Never point the first install at this current Mac. Do not link over
ServBay's `~/.bash_profile`; it is not managed by this repository.

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

Use [`docs/NEW_MAC_CHECKLIST.md`](docs/NEW_MAC_CHECKLIST.md) for the functional
review of each config and shortcut. macOS may require Accessibility or Input
Monitoring permission for yabai/skhd.

Write down every issue and fix it in the maintained `~/dotfiles` checkout. Rerun the
affected stage on the test Mac and repeat the relevant checks. Homebrew
downloads and macOS permission prompts can make the first install take from
under an hour to several hours; the exact time depends on the machine and
network.

## Accepting the migration

After the separate Mac checks pass, record the result and review any test
fixes. Commit and push those fixes if needed. Keep the old `~/dotfiles`
checkout available until you decide the candidate is ready for daily use.
This document does not certify a successful fresh-machine installation; that
result must be recorded after the test Mac run.

The current Mac cutover has already been explicitly approved and applied.
Its Git identity and legacy Code profile were preserved under
`~/.config/dotfiles-local`, and `~/.local/bin` is now a real directory.
The old checkout remains in the external backup described in the cutover report.

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
