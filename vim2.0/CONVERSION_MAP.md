# Conversion Map (from nvim2.0)

## Editor Options

| Neovim (Lua) | Vim (Vimscript) |
| --- | --- |
| `opt.shortmess:remove("I")` | `set shortmess-=I` |
| `opt.termguicolors = true` | `if has('termguicolors') | set termguicolors | endif` |
| `opt.swapfile = false` | `set noswapfile` |
| `opt.undofile = true` | `set undofile` + `undodir` bootstrap |
| `opt.timeoutlen = 300` | `set timeoutlen=300` |
| `opt.updatetime = 250` | `set updatetime=250` |
| `opt.scrolloff = 4` | `set scrolloff=4` |
| `opt.wrap = false` | `set nowrap` |
| `opt.cursorline = false` | `set nocursorline` |
| `opt.numberwidth = 2` | `set numberwidth=2` |
| `opt.signcolumn = "yes"` | `set signcolumn=yes` |
| `opt.foldcolumn = "0"` | `set foldcolumn=0` |
| `opt.title = true` + custom `titlestring` | `set title` + translated `set titlestring=...` |
| `opt.formatoptions:remove("o")` | `set formatoptions-=o` |
| `vim.g.mapleader = " "` | `let mapleader = ' '` |
| `vim.g.maplocalleader = "\\"` | `let maplocalleader = '\\'` |

## Keymaps (custom + core workflow)

| Neovim map | Vim map |
| --- | --- |
| `n`/`N` centered | `nnoremap n nzzzv`, `nnoremap N Nzzzv` |
| `J` keep cursor | `nnoremap J mzJ\`z` |
| `<C-d>`/`<C-u>` centered | `nnoremap <C-d> <C-d>zz`, `nnoremap <C-u> <C-u>zz` |
| Visual line move `J/K` | same move mappings in `xnoremap` |
| `<leader>d` black-hole delete | same (`"_d`) |
| `<leader>y`, `<leader>Y`, `<leader>p` clipboard helpers | same with clipboard fallback |
| `<leader>fr` replace word under cursor | same substitution map |
| `Q` disabled | `nnoremap Q <Nop>` |
| `<leader>e` Snacks explorer | `:Lexplore`/`:Explore` |
| `<C-f>` tmux sessionizer | Vimscript function + `job_start`/shell fallback |
| `<leader>fx` chmod +x | same via shell map |
| `<C-Up/Down/Left/Right>` resize | same resize maps |
| Harpoon add/menu/select | custom Vimscript + same keys (`<leader>ha`, `<leader>hh`, `<leader>1..5`) |
| LSP maps (`gra`, `grn`, `grr`, `gri`, `grt`, `[d`, `]d`) | mapped to Coc `<Plug>` actions |
| `<leader>cf`, `<leader>xx`, diagnostics list maps | mapped to Coc and quickfix/location list |
| Telescope find/grep maps | mapped to `fzf.vim` (`:Files`, `:Buffers`, `:Rg`, etc.) |

## Autocommands

| Neovim autocmd | Vim autocmd |
| --- | --- |
| `FileType python`: 4-space indentation | `augroup user_config` + `autocmd FileType python setlocal ...` |

## Language Tooling

| Neovim stack | Vim stack |
| --- | --- |
| `nvim-lspconfig` + Mason + blink + snippets | `coc.nvim` + Coc extensions + `coc-snippets` |
| `nvim-treesitter` | built-in syntax + `vim-polyglot` |
| Telescope | `fzf.vim` |
| Gitsigns | `vim-gitgutter` |
| Lualine | `vim-airline` |
