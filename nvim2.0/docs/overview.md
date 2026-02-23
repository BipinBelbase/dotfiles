# Overview

## What This Config Optimizes For

- Stability over novelty
- Predictable yearly updates
- Fast startup with lazy-loading defaults
- Clear, documented keymaps and structure

## Design Rules

- Keep LazyVim as the base distribution.
- Only keep plugins that directly help day-to-day development.
- Prefer maintained LazyVim extras over custom one-off plugin glue.
- Disable visual/noisy plugins that add churn with little value.
- Keep OS-specific behavior guarded and optional.

## Workflow Focus

- Primary: Python backend
- Secondary: React + TypeScript
- Secondary: Rust
- Supporting: AI/ML (Python-heavy)

## Structure

- `init.lua`: leader + bootstrap entrypoint
- `lua/config/options.lua`: editor options
- `lua/config/keymaps.lua`: user mappings only
- `lua/config/autocmds.lua`: targeted autocmds only
- `lua/config/lazy.lua`: plugin manager bootstrap and global lazy config
- `lua/plugins/*.lua`: plugin overrides by topic
- `docs/`: operational docs and generated keymaps
- `scripts/generate_keymaps.lua`: keymap cheatsheet generator
