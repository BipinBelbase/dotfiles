# Mac install guide

This is the install guide for the current root-level Mac setup. Start with
[`CURRENT_MAC_SETUP.md`](CURRENT_MAC_SETUP.md) to see which configs the Mac
currently loads and what the installer will change.

## Before installing

1. Install Apple's command-line tools if they are not present:

   ```sh
   xcode-select --install
   ```

2. Make sure the complete repository is available at `~/dotfiles`. If it is
   already there, inspect its Git status first and keep any local changes.
3. Preview the installer:

   ```sh
   cd ~/dotfiles
   ./install_mac.sh --dry-run
   ```

The preview retains the designed intro and pacing, so it takes a while. Read
the target and backup paths it prints. The preview does not install packages,
change links, or run tmux plugin installation.

## Run the installer

When you are ready to install, run:

```sh
./install_mac.sh
```

The designed sequence installs Homebrew if needed, installs packages from
`homebrew/Brewfile`, installs Oh My Zsh when missing, installs or updates TPM,
installs configured tmux plugins, and links the root-level Zsh, tmux, Neovim,
skhd, yabai, Ghostty, and VS Code configuration.

If `~/dotfiles` is already a Git checkout, the installer uses it in place. It
does not remove, rename, or clone over that checkout. If the path exists but
is not a Git checkout, the script stops rather than moving it.

When an existing home path conflicts with a link, the installer moves it to
an unused sibling path ending in `.bak.<timestamp>` and keeps it. Existing
symlinks are preserved the same way; the script no longer force-replaces them
or deletes an earlier backup. Ghostty is linked as a directory so the
installer does not write through an existing directory symlink.

## After installing

- Open a new terminal to load the linked shell config.
- Check Neovim, tmux, Ghostty, VS Code, and window-manager shortcuts.
- macOS may ask you to grant Accessibility and Input Monitoring permissions
  to yabai and skhd. Use `~/.config/yabai/wm-doctor.sh diagnose` to inspect
  their status.
- Homebrew and TPM may update software as part of the original install flow.
  The installer does not pin exact Homebrew versions or a TPM revision.

No installer was run while preparing this guide.
