# vim2.0 (Vim port of your nvim2.0 config)

This folder is a Vim-native conversion of your Neovim config.

## Layout

- `vim2.0/.vimrc`
- `vim2.0/.vim/plugin/harpoon.vim`
- `vim2.0/.vim/ftplugin/python.vim`
- `vim2.0/.vim/coc-settings.json`
- `vim2.0/CONVERSION_MAP.md`
- `vim2.0/COMPATIBILITY_REPORT.md`
- `vim2.0/scripts/install-native-packages.sh`

## Dependencies

Required:

- `vim` 8.2+ recommended
- `git`
- `curl` (for vim-plug bootstrap)
- `node` + `npm` (required by `coc.nvim`)
- `ripgrep` (`rg`) for `:Rg`

Optional:

- `fzf` binary (plugin bootstrap will install if missing)
- `python3` (recommended for broader tool support)
- `tmux` + `tmux-sessionizer` (for `<C-f>` mapping)

## Install (Default: vim-plug)

1. Backup existing Vim config:

```bash
mv ~/.vimrc ~/.vimrc.bak.$(date +%Y%m%d%H%M%S) 2>/dev/null || true
mv ~/.vim ~/.vim.bak.$(date +%Y%m%d%H%M%S) 2>/dev/null || true
```

2. Copy this config:

```bash
cp vim2.0/.vimrc ~/.vimrc
cp -R vim2.0/.vim ~/.vim
```

3. Start Vim and install plugins:

```vim
:PlugInstall
```

4. Restart Vim and verify Coc extensions auto-install (from `g:coc_global_extensions`).

## Alternative Plugin Strategy: Vim Native Packages (`pack/*/start`)

If you prefer no `vim-plug`, use this script:

```bash
sh vim2.0/scripts/install-native-packages.sh
```

Then copy `.vimrc`/`.vim` as above. The `.vimrc` only runs vim-plug blocks when vim-plug exists, so native packages still work.

If you want dadbod plugins in native package mode:

```bash
ENABLE_DADBOD=1 sh vim2.0/scripts/install-native-packages.sh
```

## Update Workflow

vim-plug mode:

```vim
:PlugUpdate
:CocUpdateSync
```

native package mode:

```bash
sh vim2.0/scripts/install-native-packages.sh
```

## Key Workflow Kept

- Leader: `<Space>`
- Search movement centered: `n`, `N`, `<C-d>`, `<C-u>`
- Register helpers: `<leader>d`, `<leader>y`, `<leader>Y`, `<leader>p`
- Replace word under cursor: `<leader>fr`
- Explorer: `<leader>e`
- Tmux sessionizer: `<C-f>`
- Window resize with Ctrl-arrow keys
- Harpoon-style navigation: `<leader>ha`, `<leader>hh`, `<leader>1..5`
- LSP-style actions via Coc: `gra`, `grn`, `grr`, `gri`, `grt`, `[d`, `]d`, `<leader>cf`, `<leader>xx`
- Undo tree: `<leader>cu`

## Troubleshooting

### `E117: Unknown function: plug#begin`

Install vim-plug manually:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Coc errors about Node

Install a modern Node runtime (LTS), then reopen Vim.

### `<C-s>` freezes terminal

Run once in your shell startup:

```bash
stty -ixon
```

### `:Rg` not found or empty

Install `ripgrep` and confirm `rg --version` works in your shell.

### Clipboard mappings do not use system clipboard

Your Vim likely lacks clipboard support. Check:

```vim
:echo has('clipboard')
```

If it prints `0`, install a Vim build with clipboard support.

### LSP/completion not active

Check Coc status and extensions:

```vim
:CocInfo
:CocList extensions
:CocList services
```
