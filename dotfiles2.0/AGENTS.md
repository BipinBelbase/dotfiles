# Working in dotfiles2.0

This subtree is the planned successor to the root-level Mac setup.

- Treat root-level config folders as read-only references. Make migration and
  organization changes only inside `dotfiles2.0/` unless the user explicitly
  asks otherwise.
- Preserve current Neovim shortcuts, tmux bindings, shell aliases/functions,
  Ghostty settings, yabai/skhd behavior, and the install artwork when changing
  their copies here. Compare against root sources before changing behavior.
- Never run an installer, dry run, package restore, or link-changing command
  on the user's Mac. This preference is explicit and permanent.
- Do not claim a clean install is verified without a separate approved test
  machine. State what was inspected and what remains unverified.
- Keep Mac as the supported migration target for now. Treat Linux and Windows
  support as future work.
- Inspect Git status before editing and review the diff afterward. Keep
  credentials, API keys, private assistant settings, and datasets out of Git.
