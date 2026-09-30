# Planning for Linux

This is a staged plan for bringing the dotfiles to Linux, starting with Fedora
in VMware and then using the lessons from that VM to prepare an Arch Linux
install. The current Mac setup remains the reliable daily setup while this
work is being explored.

## What we can do together in a VM

You can use ChatGPT in a browser inside Fedora and follow commands there. I
cannot automatically see or control the VM's terminal just because ChatGPT is
open in its browser. To let me review the real machine state, share terminal
output or screenshots here, or provide an explicitly connected terminal/UI
session if one is available. Start with read-only checks; before commands that
install packages or change links, I will show what they do and use the VM as a
reversible test environment.

VM snapshots are useful checkpoints: take one after Fedora is installed and
updated, before dotfiles changes, and after a working baseline. Keep the Mac
checkout and its live configuration links untouched during the Linux trial.

## Stages

### 1. Inventory Fedora

- Confirm Fedora release, desktop environment, shell, terminal, keyboard
  layout, display size, VMware Tools status, and whether the VM uses Wayland or
  X11.
- Capture the installed-package baseline and inspect the cloned repository's
  Git status.
- Decide which everyday tasks matter first: terminal and shell, Neovim, tmux,
  Git, fonts, development languages, and file/navigation shortcuts.
- Check shared clipboard, shared folders, resolution, and keyboard handling in
  VMware before tuning dotfiles.

### 2. Make a minimal Fedora profile

- Begin with a small CLI group and install only what is needed to clone and
  inspect the repository.
- Review package names against Fedora repositories and identify optional or
  Mac-only packages before installation.
- Install configurations one at a time, starting with shell, Git, terminal,
  tmux, and Neovim. Preserve existing files with backups and record each link
  that is created.
- Keep GUI and desktop/window-management choices separate from the terminal
  baseline so the setup works with the VM's actual desktop session.

### 3. Validate and record the Fedora result

- Check that login shells start cleanly, terminal colors and fonts work,
  Neovim plugins and language tools are available, tmux starts, and common
  development workflows run.
- Review the home-directory links and installer logs; fix issues before
  expanding package groups.
- Record Fedora-specific package mappings, skipped software, required manual
  steps, and tested commands in the Linux setup docs.
- Turn successful manual fixes into repeatable installer steps only after
  confirming they are safe to rerun.

### 4. Prepare Arch from the Fedora findings

- Use a separate Arch VM or snapshot; do not use the Fedora instructions as an
  Arch install guide.
- First complete and update the base Arch installation, establish networking,
  a user with sudo access, a graphical desktop if desired, and VMware guest
  integration.
- Reuse the same configuration modules where they are portable, with a
  separate package map and explicit Arch-only notes where needed.
- Re-run the same functional checks and document package or service differences
  before considering the Arch setup ready for a real machine.

## Current repository findings and gaps

- The current candidate is Mac-first. Its `stow/` folders organize
  application settings, while `install_mac.sh` creates the links itself; GNU
  Stow is not currently a required installer dependency.
- There is no Linux or Windows installer or package mapping in this candidate.
  Do not run the Mac installer on Linux.
- Neovim, tmux, and much of Zsh may be portable after checking their package
  dependencies and machine-specific paths. Ghostty, yabai, skhd, Raycast, and
  VS Code need platform-specific review. yabai/skhd are macOS window-manager
  tools and their current shortcuts cannot be assumed to work on Linux.
- Start with Fedora in a disposable VM. Add only the needed portable modules
  after testing them there; choose a Linux desktop/window manager before
  designing desktop shortcuts.
- Do not copy files from the old AI-created `dotfiles2.0` installer or claim
  its Fedora/Arch support applies to this candidate. The trusted main-tree
  settings remain the source for any future port.

## Making setup lighter

- Separate a small bootstrap (Git, Stow, shell, terminal, editor) from optional
  groups for languages, GUI apps, fonts, and desktop/window tools.
- Prefer distro packages for the base system and use per-distro mappings for
  differences. Avoid downloading every tool on the first pass.
- Keep a concise list of commands that worked and the reason each extra package
  is needed. This gives us a repeatable install instead of rediscovering the
  same dependencies on each VM.
- For shortcuts to frequently used folders or commands on the home screen,
  decide whether you mean desktop launchers, shell aliases, or file-manager
  bookmarks. Linux implements these differently; capture the desired targets
  during Fedora inventory and add the appropriate setup only after that is
  clear.

## Safe working sequence

1. Check `git status` before editing and keep experimental Linux work in its
   own commit or branch.
2. Preview installer actions before applying them. Never run the Mac installer
   in a Linux VM.
3. Back up conflicting files and inspect links before replacing anything.
4. Verify each stage in the VM, then update this plan and the relevant
   installer documentation with tested results.
5. Treat Fedora as the learning environment; carry confirmed, portable fixes
   into Arch and verify them there separately.

This plan describes work to do; it does not claim that Fedora or Arch
installation steps have been run or verified.
