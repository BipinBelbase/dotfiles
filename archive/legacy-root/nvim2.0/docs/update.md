# Yearly Update Guide

## Goal

Update once per year with minimal breakage and keep plugin versions pinned in `lazy-lock.json`.

## Checklist

1. Create a branch for the yearly update.
2. Upgrade to latest stable Neovim.
3. Start with locked versions:
   - `:Lazy restore`
4. Validate baseline:
   - `:checkhealth`
   - open Python, TypeScript, and Rust files and confirm LSP + formatting.
5. Update plugins intentionally:
   - `:Lazy update`
6. Re-check runtime:
   - `:checkhealth`
   - `:Mason`
7. Regenerate keymap docs:
   - `cd ~/.config/nvim`
   - `nvim --headless '+lua dofile("scripts/generate_keymaps.lua")' +qa`
8. Review and commit:
   - `lazy-lock.json`
   - config changes
   - docs changes

## Rules for Safe Upgrades

- Do not use nightly-only APIs.
- Keep optional plugins behind toggles.
- Prefer removing brittle plugins over patching around breakages.
- Always commit lockfile changes with config changes.
