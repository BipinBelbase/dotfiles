# Instructions for work in this repository

- Make changes only in this migration worktree unless the user explicitly
  changes scope. The user's normal `~/dotfiles` checkout is the trusted source
  and must not be modified by migration work.
- Use the root `main` configuration files as the source of behavior, shortcuts,
  and settings. The `dotfiles2.0` project only informed the package layout;
  do not copy its config content, installer, or package definitions.
- Read `docs/MIGRATION_STATUS.md` before continuing migration work.
- Preserve the original installer's artwork and style when updating the
  candidate installer. Keep changes focused on the new paths, portability,
  and restartable stages.
- Do not run the installer, package managers, link-changing commands, or tests
  on the user's current Mac. Installation validation is for a separate Mac.
- Keep machine-generated state, credentials, ServBay's Bash profile, and
  runtime history out of Git.
- Explain consequential changes and never claim an install or test passed
  unless it actually ran on the separate test Mac.

## After migration acceptance

The canonical maintained config is `stow/<app>` plus `packages/Brewfile`.
`archive/legacy-root` is a frozen reference, not a second editable config.
The source-main rule above records migration provenance; it does not require
future changes to be duplicated into legacy files. Keep the migration status
as history and record separate-Mac results before removing these restrictions.
Prefer focused changes and commits. Add machine overrides or other platform
installers only for actual requirements; preserve mappings and artwork unless
the user asks to change them. Never switch this source Mac automatically.
