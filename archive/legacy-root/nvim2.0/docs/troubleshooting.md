# Troubleshooting

## Wrong Config Directory Is Loading

Check:

```bash
ls -ld ~/.config/nvim
```

If it does not point to `~/dotfiles/nvim`, relink:

```bash
ln -sfn ~/dotfiles/nvim ~/.config/nvim
```

## Plugins Not Matching `lazy-lock.json`

Inside Neovim:

```vim
:Lazy restore
```

Then restart Neovim.

## LSP Not Attaching

1. Run `:checkhealth`.
2. Open `:Mason` and verify required servers/tools are installed.
3. Confirm project root has expected config files (`pyproject.toml`, `package.json`, `Cargo.toml`, etc.).

## Formatter/Linter Missing

Run:

```vim
:Mason
```

Install missing tools from the configured list (`stylua`, `prettier`, `shfmt`, `eslint_d`, and language servers via mason-lspconfig).

## Keymap Cheatsheet Is Outdated

Regenerate from live config:

```bash
cd ~/.config/nvim
nvim --headless '+lua dofile("scripts/generate_keymaps.lua")' +qa
```

This rewrites:

- `docs/keymaps.md`
