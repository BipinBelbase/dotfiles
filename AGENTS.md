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

Use `./install_mac.sh --check` before considering a full rerun. When every
managed link and dependency passes, rerunning skips matching setup. Homebrew
may refresh local metadata during its check; a missing dependency or link can
still cause the installer to act. The completed cutover does not authorize
package reinstalls, service restarts, pushes, or replacement of backups. Ask
before those consequential actions unless the user's current task authorizes
them. Tests were
requested for this cutover; future tests follow the user's requested scope.
Report exactly what was checked and distinguish syntax/startup checks from
manual GUI shortcuts and clean-machine installation. Keep backup instructions
current. Do not claim every workflow works from a startup check alone.

## yabai/skhd troubleshooting

Read `docs/YABAI_TROUBLESHOOTING.md` before diagnosing these tools. The user's
intended workflow is **Cmd+number -> skhd -> yabai**, including instant Space
switching. Preserve it. Do not substitute native Control shortcuts, another
window manager, or a fallback backend, or change Mission Control/animation/
Accessibility/SIP settings without explaining the exact change and obtaining
explicit approval. Approval to debug is not approval to redesign the workflow.

Inspect the live symlinks, Git diff, `~/src/yabai`, installed signing identity,
macOS build, Dock hash, and actual payload capabilities before concluding the
OS is unsupported. A patched local binary may differ from upstream despite
reporting the same yabai version. Preserve local source work. Keep candidate
builds separate until reviewed; do not blindly run a fork's installer.
A responsive daemon socket or exit status 0 does not prove Space switching.
After an approved repair, check actual focused-Space state, original shortcuts,
and move-and-follow, then restore the user's original window and Space.
Back up binary, payload and scoped sudo rule before replacement; keep stable
code signing and hash-pinned sudo authorization. Never silently widen sudo access.
Document proven results and remaining limitations; don't claim all workflows
work after a compile or socket check. Keep the incident notes and patch below
current rather than hard-coding old offsets for a later macOS build.
