# Compatibility Report: nvim2.0 -> vim2.0

| Neovim feature/plugin | Vim replacement | Parity | Notes |
| --- | --- | --- | --- |
| `init.lua` + Lua module graph | `~/.vimrc` + `.vim/` Vimscript files | Full | Entire setup converted to Vimscript; no `vim.*` API usage remains. |
| `lazy.nvim` + `LazyVim` distro | `vim-plug` + explicit plugin/config wiring | Partial | Behavior is preserved for your active workflow, but LazyVim auto-discovery and dynamic defaults are not present. |
| `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig` + `mason-tool-installer` | `coc.nvim` + Coc extensions (`coc-json`, `coc-pyright`, `coc-tsserver`, etc.) | Partial | Closest interactive parity (rename/code actions/diagnostics/completion), but no Mason-style tool UI/installer. |
| `blink.cmp` completion | `coc.nvim` completion popup | Partial | Equivalent completion UX, but engine internals and exact ranking differ. |
| Snippets (`friendly-snippets`/LazyVim snippet flow) | `coc-snippets` + `<C-l>` jump/expand | Partial | Snippets work, but exact Tab-jump behavior differs slightly from Neovim setup. |
| `nvim-treesitter` (+ textobjects, autotag) | Vim syntax + `vim-polyglot` + `matchit` | Partial | Good syntax coverage, but no Tree-sitter parse accuracy, textobject ecosystem, or TS-powered structural features. |
| `telescope.nvim` | `fzf.vim` (`:Files`, `:Buffers`, `:Rg`, etc.) | Partial | Fast fuzzy-finding parity for day-to-day use; Telescope-specific pickers/UI are different. |
| `snacks` explorer (`<leader>e`) | Built-in netrw (`:Lexplore`, `:Explore`) | Partial | File explorer preserved via built-in Vim, but lacks Snacks UI features. |
| `harpoon2` | Custom Vimscript harpoon (`.vim/plugin/harpoon.vim`) | Partial | Add/select/menu workflow preserved (`<leader>ha`, `<leader>hh`, `<leader>1..5`), with a simpler menu UI. |
| `gitsigns.nvim` | `vim-gitgutter` | Partial | Sign-column git changes preserved, but no inline hunk preview/actions parity with Gitsigns API. |
| `lualine.nvim` | `vim-airline` | Partial | Stable statusline with diagnostics/diff support, but not 1:1 section behavior. |
| `tokyonight.nvim` | `ghifarit53/tokyonight-vim` | Partial | Theme family preserved; exact highlight groups can differ across Vim/Neovim implementations. |
| `trouble.nvim` | `:CocList diagnostics` + quickfix/location list maps | Partial | Diagnostics list navigation is preserved; Trouble panel UX is not identical. |
| `undotree` | `undotree` (same plugin) | Full | Same plugin and key workflow via `<leader>cu`. |
| `vim-dadbod-ui` stack | same Vim plugins (`vim-dadbod`, `vim-dadbod-ui`, completion) | Full | Feature parity when `g:enable_dadbod=1`. |
| `mini.pairs` | `jiangmiao/auto-pairs` | Partial | Auto-pairing preserved, but pairing rules/motions differ from MiniPairs. |
| `ts-comments`/comment mappings | `tpope/vim-commentary` | Partial | `gc` commenting workflow preserved, but TS-contextual comment behavior can differ. |
| LazyVim formatting toggles (`<leader>uf`, `<leader>uF`) | Vimscript autoformat toggles + Coc format on save | Partial | Same key workflow exists; formatting backend differs from Conform/LazyVim pipeline. |
| Neovim `winborder`/floating border controls | Not available in classic Vim core UI | Not possible | Vim popup/floating support is more limited; no exact equivalent for Neovim window border behavior. |
| Disabled Neovim plugins (`noice`, `flash`, etc.) | Omitted | Full | No behavioral impact because they were already disabled in your source config. |
