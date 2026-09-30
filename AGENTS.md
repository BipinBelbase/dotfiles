# Instructions for AI helpers

## Current setup

The user explicitly approved the live Mac cutover on 2026-09-30. This
`~/dotfiles` checkout on `main` is now the maintained configuration. Read
`docs/CUTOVER_REPORT.md` before changing paths and inspect Git status and live
symlink targets. `docs/MIGRATION_STATUS.md` records the earlier preparation;
its former candidate-only restrictions describe that historical phase.

## Maintain one source

- Edit `stow/<app>` for configs and `packages/Brewfile` for desired packages.
- Keep `archive/legacy-root` frozen as a comparison reference. Do not recreate
  nested dotfiles versions or duplicate changes into the archive.
- Preserve all mappings, artwork, and application behavior unless the user
  specifically requests a change. Prefer small, focused commits.
- Focus on macOS. Linux/Windows support and machine overrides should follow
  real requirements, not speculative abstractions.
- Git identity and the legacy Code profile are local under
  `~/.config/dotfiles-local`; do not copy their private settings into Git.
- Leave ServBay's `~/.bash_profile`, runtime state, plugin installations,
  credentials, datasets, and unrelated home files alone.

## Changes and verification

The completed cutover does not authorize future package reinstalls, service
restarts, pushes, or replacement of backups. Ask before consequential new
setup changes unless the user's current task authorizes them. Never run the
full installer on this configured Mac for a routine edit. Tests were
requested for this cutover; future tests follow the user's requested scope.
Report exactly what was checked and distinguish syntax/startup checks from
manual GUI shortcuts and clean-machine installation. Keep backup instructions
current. Do not claim every workflow works from a startup check alone.
