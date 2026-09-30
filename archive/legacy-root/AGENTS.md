# Instructions for AI helpers

Read [`CURRENT_MAC_SETUP.md`](CURRENT_MAC_SETUP.md) and check Git status and
the live home-directory links before changing this setup.

## Scope

- The user's current system is macOS. Keep work focused on the existing Mac
  setup; Linux and Windows are later goals.
- Treat `dotfiles2.0/` as future reference. Do not edit files in that subtree,
  synchronize into it, or run its installer as part of current-setup work.
- Check the symlink target before editing a config. A root-level duplicate
  may not be the file the Mac currently loads.

## Safe working rules

- Preserve user changes. Inspect `git status` before and after each change.
- Explain meaningful changes and their effects. Avoid unrelated cosmetic
  edits or broad reformatting.
- Do not run `install_mac.sh`, package installation, or link-changing
  commands; do not move/delete config folders, replace backups, or change
  home-directory symlinks without explicit approval for that action.
- Do not add or run tests unless requested. Never claim a command succeeded
  unless it was actually run.
- Keep secrets and private assistant settings out of Git.
