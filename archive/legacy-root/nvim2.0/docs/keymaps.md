# Keymaps

Generated from the live Neovim config on startup (`nvim --headless`) so it stays in sync with LazyVim defaults and local overrides.

- Leader key: `<Space>`
- Generated at: `2026-02-23 10:02:17Z`
- Total keymaps: `359`

## Code and LSP

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `<leader>cF` | `n` | Format Injected Langs | `conform.nvim` |
| `<leader>cf` | `n` | Format | `LazyVim core` |
| `<leader>cm` | `n` | Mason | `LazyVim core` |
| `<leader>cu` | `n` | Undo tree | `undotree` |
| `<leader>uF` | `n` | Toggle Auto Format (Buffer) | `LazyVim core` |
| `<leader>uf` | `n` | Toggle Auto Format (Global) | `LazyVim core` |
| `gra` | `n` | vim.lsp.buf.code_action() | `LazyVim core` |
| `grn` | `n` | vim.lsp.buf.rename() | `LazyVim core` |
| `<leader>cF` | `v` | Format Injected Langs | `conform.nvim` |
| `<leader>cf` | `v` | Format | `LazyVim core` |
| `gra` | `v` | vim.lsp.buf.code_action() | `LazyVim core` |
| `<leader>cF` | `x` | Format Injected Langs | `conform.nvim` |
| `<leader>cf` | `x` | Format | `LazyVim core` |
| `gra` | `x` | vim.lsp.buf.code_action() | `LazyVim core` |

## Diagnostics and Lists

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `<C-W><C-D>` | `n` | Show diagnostics under the cursor | `LazyVim core` |
| `<C-W>d` | `n` | Show diagnostics under the cursor | `LazyVim core` |
| `<leader>cS` | `n` | LSP references/definitions/... (Trouble) | `LazyVim core` |
| `<leader>cd` | `n` | Line Diagnostics | `LazyVim core` |
| `<leader>cs` | `n` | Symbols (Trouble) | `LazyVim core` |
| `<leader>sD` | `n` | Buffer Diagnostics | `telescope.nvim` |
| `<leader>sd` | `n` | Diagnostics | `telescope.nvim` |
| `<leader>sq` | `n` | Quickfix List | `telescope.nvim` |
| `<leader>ud` | `n` | Toggle Diagnostics | `LazyVim core` |
| `<leader>xL` | `n` | Location List (Trouble) | `LazyVim core` |
| `<leader>xQ` | `n` | Quickfix List (Trouble) | `LazyVim core` |
| `<leader>xX` | `n` | Buffer Diagnostics (Trouble) | `LazyVim core` |
| `<leader>xl` | `n` | Location List | `LazyVim core` |
| `<leader>xq` | `n` | Quickfix List | `LazyVim core` |
| `<leader>xx` | `n` | Diagnostics (Trouble) | `LazyVim core` |
| `[D` | `n` | Jump to the first diagnostic in the current buffer | `LazyVim core` |
| `[d` | `n` | Prev Diagnostic | `LazyVim core` |
| `[q` | `n` | Previous Trouble/Quickfix Item | `LazyVim core` |
| `]D` | `n` | Jump to the last diagnostic in the current buffer | `LazyVim core` |
| `]d` | `n` | Next Diagnostic | `LazyVim core` |
| `]q` | `n` | Next Trouble/Quickfix Item | `LazyVim core` |

## Editing and Misc

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `"` | `c` | Closeopen action for '""' pair | `LazyVim core` |
| `'` | `c` | Closeopen action for "''" pair | `LazyVim core` |
| `(` | `c` | Open action for "()" pair | `LazyVim core` |
| `)` | `c` | Close action for "()" pair | `LazyVim core` |
| `<BS>` | `c` | MiniPairs <BS> | `LazyVim core` |
| `[` | `c` | Open action for "[]" pair | `LazyVim core` |
| `]` | `c` | Close action for "[]" pair | `LazyVim core` |
| ``` | `c` | Closeopen action for "``" pair | `LazyVim core` |
| `{` | `c` | Open action for "{}" pair | `LazyVim core` |
| `}` | `c` | Close action for "{}" pair | `LazyVim core` |
| `"` | `i` | Closeopen action for '""' pair | `LazyVim core` |
| `'` | `i` | Closeopen action for "''" pair | `LazyVim core` |
| `(` | `i` | Open action for "()" pair | `LazyVim core` |
| `)` | `i` | Close action for "()" pair | `LazyVim core` |
| `,` | `i` | ,<C-G>u | `LazyVim core` |
| `.` | `i` | .<C-G>u | `LazyVim core` |
| `;` | `i` | ;<C-G>u | `LazyVim core` |
| `<BS>` | `i` | MiniPairs <BS> | `LazyVim core` |
| `<C-S>` | `i` | Save File | `LazyVim core` |
| `<C-U>` | `i` | :help i_CTRL-U-default | `LazyVim core` |
| `<C-W>` | `i` | :help i_CTRL-W-default | `LazyVim core` |
| `<CR>` | `i` | MiniPairs <CR> | `LazyVim core` |
| `<M-j>` | `i` | Move Down | `LazyVim core` |
| `<M-k>` | `i` | Move Up | `LazyVim core` |
| `<S-Tab>` | `i` | vim.snippet.jump if active, otherwise <S-Tab> | `LazyVim core` |
| `<Tab>` | `i` | vim.snippet.jump if active, otherwise <Tab> | `LazyVim core` |
| `[` | `i` | Open action for "[]" pair | `LazyVim core` |
| `]` | `i` | Close action for "[]" pair | `LazyVim core` |
| ``` | `i` | Closeopen action for "``" pair | `LazyVim core` |
| `{` | `i` | Open action for "{}" pair | `LazyVim core` |
| `}` | `i` | Close action for "{}" pair | `LazyVim core` |
| `%` | `n` | <Plug>(MatchitNormalForward) | `LazyVim core` |
| `&` | `n` | :help &-default | `LazyVim core` |
| `<C-D>` | `n` | Half-page down (centered) | `User config` |
| `<C-Down>` | `n` | Decrease window height | `User config` |
| `<C-F>` | `n` | Tmux Sessionizer | `User config` |
| `<C-H>` | `n` | Go to Left Window | `LazyVim core` |
| `<C-J>` | `n` | Go to Lower Window | `LazyVim core` |
| `<C-K>` | `n` | Go to Upper Window | `LazyVim core` |
| `<C-L>` | `n` | Go to Right Window | `LazyVim core` |
| `<C-Left>` | `n` | Decrease window width | `User config` |
| `<C-Right>` | `n` | Increase window width | `User config` |
| `<C-S>` | `n` | Save File | `LazyVim core` |
| `<C-U>` | `n` | Half-page up (centered) | `User config` |
| `<C-Up>` | `n` | Increase window height | `User config` |
| `<C-W> ` | `n` | Window Hydra Mode (which-key) | `LazyVim core` |
| `<C-_>` | `n` | which_key_ignore | `LazyVim core` |
| `<Down>` | `n` | Down | `LazyVim core` |
| `<M-j>` | `n` | Move Down | `LazyVim core` |
| `<M-k>` | `n` | Move Up | `LazyVim core` |
| `<Up>` | `n` | Up | `LazyVim core` |
| `<leader>,` | `n` | Switch Buffer | `telescope.nvim` |
| `<leader>-` | `n` | Split Window Below | `LazyVim core` |
| `<leader>/` | `n` | Grep (Root Dir) | `telescope.nvim` |
| `<leader>:` | `n` | Command History | `telescope.nvim` |
| `<leader><Tab><Tab>` | `n` | New Tab | `LazyVim core` |
| `<leader><Tab>[` | `n` | Previous Tab | `LazyVim core` |
| `<leader><Tab>]` | `n` | Next Tab | `LazyVim core` |
| `<leader><Tab>d` | `n` | Close Tab | `LazyVim core` |
| `<leader><Tab>f` | `n` | First Tab | `LazyVim core` |
| `<leader><Tab>l` | `n` | Last Tab | `LazyVim core` |
| `<leader><Tab>o` | `n` | Close Other Tabs | `LazyVim core` |
| `<leader>?` | `n` | Buffer Keymaps (which-key) | `LazyVim core` |
| `<leader>K` | `n` | Keywordprg | `LazyVim core` |
| `<leader>L` | `n` | LazyVim Changelog | `LazyVim core` |
| `<leader>S` | `n` | Select Scratch Buffer | `LazyVim core` |
| `<leader>Y` | `n` | Yank line to system clipboard | `User config` |
| `<leader>`` | `n` | Switch to Other Buffer | `LazyVim core` |
| `<leader>bD` | `n` | Delete Buffer and Window | `LazyVim core` |
| `<leader>bb` | `n` | Switch to Other Buffer | `LazyVim core` |
| `<leader>bd` | `n` | Delete Buffer | `LazyVim core` |
| `<leader>bo` | `n` | Delete Other Buffers | `LazyVim core` |
| `<leader>d` | `n` | Delete without yanking | `User config` |
| `<leader>dps` | `n` | Profiler Scratch Buffer | `LazyVim core` |
| `<leader>l` | `n` | Lazy | `LazyVim core` |
| `<leader>n` | `n` | Notification History | `LazyVim core` |
| `<leader>qq` | `n` | Quit All | `LazyVim core` |
| `<leader>s"` | `n` | Registers | `telescope.nvim` |
| `<leader>sC` | `n` | Commands | `telescope.nvim` |
| `<leader>sG` | `n` | Grep (cwd) | `telescope.nvim` |
| `<leader>sM` | `n` | Man Pages | `telescope.nvim` |
| `<leader>sR` | `n` | Resume | `telescope.nvim` |
| `<leader>sS` | `n` | Goto Symbol (Workspace) | `telescope.nvim` |
| `<leader>sW` | `n` | Word (cwd) | `telescope.nvim` |
| `<leader>sa` | `n` | Auto Commands | `telescope.nvim` |
| `<leader>sb` | `n` | Buffer Lines | `telescope.nvim` |
| `<leader>sc` | `n` | Command History | `telescope.nvim` |
| `<leader>sg` | `n` | Grep (Root Dir) | `telescope.nvim` |
| `<leader>sh` | `n` | Help Pages | `telescope.nvim` |
| `<leader>sj` | `n` | Jumplist | `telescope.nvim` |
| `<leader>sk` | `n` | Key Maps | `telescope.nvim` |
| `<leader>sl` | `n` | Location List | `telescope.nvim` |
| `<leader>sm` | `n` | Jump to Mark | `telescope.nvim` |
| `<leader>so` | `n` | Options | `telescope.nvim` |
| `<leader>ss` | `n` | Goto Symbol | `telescope.nvim` |
| `<leader>sw` | `n` | Word (Root Dir) | `telescope.nvim` |
| `<leader>wd` | `n` | Delete Window | `LazyVim core` |
| `<leader>y` | `n` | Yank to system clipboard | `User config` |
| `<leader>\|` | `n` | Split Window Right | `LazyVim core` |
| `H` | `n` | Prev Buffer | `LazyVim core` |
| `J` | `n` | Join line below without moving cursor | `User config` |
| `L` | `n` | Next Buffer | `LazyVim core` |
| `Q` | `n` | Disable Ex mode | `User config` |
| `Y` | `n` | :help Y-default | `LazyVim core` |
| `[ ` | `n` | Add empty line above cursor | `LazyVim core` |
| `[%` | `n` | <Plug>(MatchitNormalMultiBackward) | `LazyVim core` |
| `[<C-L>` | `n` | :lpfile | `LazyVim core` |
| `[<C-Q>` | `n` | :cpfile | `LazyVim core` |
| `[<C-T>` | `n` | :ptprevious | `LazyVim core` |
| `[A` | `n` | :rewind | `LazyVim core` |
| `[B` | `n` | :brewind | `LazyVim core` |
| `[L` | `n` | :lrewind | `LazyVim core` |
| `[Q` | `n` | :crewind | `LazyVim core` |
| `[T` | `n` | :trewind | `LazyVim core` |
| `[a` | `n` | :previous | `LazyVim core` |
| `[b` | `n` | Prev Buffer | `LazyVim core` |
| `[e` | `n` | Prev Error | `LazyVim core` |
| `[l` | `n` | :lprevious | `LazyVim core` |
| `[t` | `n` | :tprevious | `LazyVim core` |
| `[w` | `n` | Prev Warning | `LazyVim core` |
| `] ` | `n` | Add empty line below cursor | `LazyVim core` |
| `]%` | `n` | <Plug>(MatchitNormalMultiForward) | `LazyVim core` |
| `]<C-L>` | `n` | :lnfile | `LazyVim core` |
| `]<C-Q>` | `n` | :cnfile | `LazyVim core` |
| `]<C-T>` | `n` | :ptnext | `LazyVim core` |
| `]A` | `n` | :last | `LazyVim core` |
| `]B` | `n` | :blast | `LazyVim core` |
| `]L` | `n` | :llast | `LazyVim core` |
| `]Q` | `n` | :clast | `LazyVim core` |
| `]T` | `n` | :tlast | `LazyVim core` |
| `]a` | `n` | :next | `LazyVim core` |
| `]b` | `n` | Next Buffer | `LazyVim core` |
| `]e` | `n` | Next Error | `LazyVim core` |
| `]l` | `n` | :lnext | `LazyVim core` |
| `]t` | `n` | :tnext | `LazyVim core` |
| `]w` | `n` | Next Warning | `LazyVim core` |
| `g%` | `n` | <Plug>(MatchitNormalBackward) | `LazyVim core` |
| `gO` | `n` | vim.lsp.buf.document_symbol() | `LazyVim core` |
| `g[` | `n` | Move to left "around" | `LazyVim core` |
| `g]` | `n` | Move to right "around" | `LazyVim core` |
| `gcO` | `n` | Add Comment Above | `LazyVim core` |
| `gco` | `n` | Add Comment Below | `LazyVim core` |
| `gri` | `n` | vim.lsp.buf.implementation() | `LazyVim core` |
| `grr` | `n` | vim.lsp.buf.references() | `LazyVim core` |
| `grt` | `n` | vim.lsp.buf.type_definition() | `LazyVim core` |
| `j` | `n` | Down | `LazyVim core` |
| `k` | `n` | Up | `LazyVim core` |
| `%` | `o` | <Plug>(MatchitOperationForward) | `LazyVim core` |
| `[%` | `o` | <Plug>(MatchitOperationMultiBackward) | `LazyVim core` |
| `]%` | `o` | <Plug>(MatchitOperationMultiForward) | `LazyVim core` |
| `a` | `o` | Around textobject | `LazyVim core` |
| `al` | `o` | Around last textobject | `LazyVim core` |
| `an` | `o` | Around next textobject | `LazyVim core` |
| `g%` | `o` | <Plug>(MatchitOperationBackward) | `LazyVim core` |
| `g[` | `o` | Move to left "around" | `LazyVim core` |
| `g]` | `o` | Move to right "around" | `LazyVim core` |
| `gc` | `o` | Comment textobject | `LazyVim core` |
| `i` | `o` | Inside textobject | `LazyVim core` |
| `il` | `o` | Inside last textobject | `LazyVim core` |
| `in` | `o` | Inside next textobject | `LazyVim core` |
| `<C-S>` | `s` | Save File | `LazyVim core` |
| `<M-j>` | `s` | Move Down | `LazyVim core` |
| `<M-k>` | `s` | Move Up | `LazyVim core` |
| `<S-Tab>` | `s` | vim.snippet.jump if active, otherwise <S-Tab> | `LazyVim core` |
| `<Tab>` | `s` | vim.snippet.jump if active, otherwise <Tab> | `LazyVim core` |
| `<leader>y` | `s` | Yank to system clipboard | `User config` |
| `J` | `s` | Move selection down | `LazyVim core` |
| `K` | `s` | Move selection up | `LazyVim core` |
| `<C-_>` | `t` | which_key_ignore | `LazyVim core` |
| `#` | `v` | :help v_#-default | `LazyVim core` |
| `%` | `v` | <Plug>(MatchitVisualForward) | `LazyVim core` |
| `*` | `v` | :help v_star-default | `LazyVim core` |
| `<C-S>` | `v` | Save File | `LazyVim core` |
| `<Down>` | `v` | Down | `LazyVim core` |
| `<M-j>` | `v` | Move Down | `LazyVim core` |
| `<M-k>` | `v` | Move Up | `LazyVim core` |
| `<S-Tab>` | `v` | vim.snippet.jump if active, otherwise <S-Tab> | `LazyVim core` |
| `<Tab>` | `v` | vim.snippet.jump if active, otherwise <Tab> | `LazyVim core` |
| `<Up>` | `v` | Up | `LazyVim core` |
| `<leader>d` | `v` | Delete without yanking | `User config` |
| `<leader>p` | `v` | Paste over selection | `LazyVim core` |
| `<leader>sW` | `v` | Selection (cwd) | `telescope.nvim` |
| `<leader>sw` | `v` | Selection (Root Dir) | `telescope.nvim` |
| `<leader>y` | `v` | Yank to system clipboard | `User config` |
| `<lt>` | `v` | <lt>gv | `LazyVim core` |
| `>` | `v` | >gv | `LazyVim core` |
| `@` | `v` | :help v_@-default | `LazyVim core` |
| `J` | `v` | Move selection down | `User config` |
| `K` | `v` | Move selection up | `User config` |
| `Q` | `v` | :help v_Q-default | `LazyVim core` |
| `[%` | `v` | <Plug>(MatchitVisualMultiBackward) | `LazyVim core` |
| `]%` | `v` | <Plug>(MatchitVisualMultiForward) | `LazyVim core` |
| `a` | `v` | Around textobject | `LazyVim core` |
| `a%` | `v` | <Plug>(MatchitVisualTextObject) | `LazyVim core` |
| `al` | `v` | Around last textobject | `LazyVim core` |
| `an` | `v` | Around next textobject | `LazyVim core` |
| `g%` | `v` | <Plug>(MatchitVisualBackward) | `LazyVim core` |
| `g[` | `v` | Move to left "around" | `LazyVim core` |
| `g]` | `v` | Move to right "around" | `LazyVim core` |
| `i` | `v` | Inside textobject | `LazyVim core` |
| `il` | `v` | Inside last textobject | `LazyVim core` |
| `in` | `v` | Inside next textobject | `LazyVim core` |
| `j` | `v` | Down | `LazyVim core` |
| `k` | `v` | Up | `LazyVim core` |
| `#` | `x` | :help v_#-default | `LazyVim core` |
| `%` | `x` | <Plug>(MatchitVisualForward) | `LazyVim core` |
| `*` | `x` | :help v_star-default | `LazyVim core` |
| `<C-S>` | `x` | Save File | `LazyVim core` |
| `<Down>` | `x` | Down | `LazyVim core` |
| `<M-j>` | `x` | Move Down | `LazyVim core` |
| `<M-k>` | `x` | Move Up | `LazyVim core` |
| `<Up>` | `x` | Up | `LazyVim core` |
| `<leader>d` | `x` | Delete without yanking | `User config` |
| `<leader>p` | `x` | Paste over selection | `User config` |
| `<leader>sW` | `x` | Selection (cwd) | `telescope.nvim` |
| `<leader>sw` | `x` | Selection (Root Dir) | `telescope.nvim` |
| `<leader>y` | `x` | Yank to system clipboard | `User config` |
| `<lt>` | `x` | <lt>gv | `LazyVim core` |
| `>` | `x` | >gv | `LazyVim core` |
| `@` | `x` | :help v_@-default | `LazyVim core` |
| `J` | `x` | Move selection down | `LazyVim core` |
| `K` | `x` | Move selection up | `LazyVim core` |
| `Q` | `x` | :help v_Q-default | `LazyVim core` |
| `[%` | `x` | <Plug>(MatchitVisualMultiBackward) | `LazyVim core` |
| `]%` | `x` | <Plug>(MatchitVisualMultiForward) | `LazyVim core` |
| `a` | `x` | Around textobject | `LazyVim core` |
| `a%` | `x` | <Plug>(MatchitVisualTextObject) | `LazyVim core` |
| `al` | `x` | Around last textobject | `LazyVim core` |
| `an` | `x` | Around next textobject | `LazyVim core` |
| `g%` | `x` | <Plug>(MatchitVisualBackward) | `LazyVim core` |
| `g[` | `x` | Move to left "around" | `LazyVim core` |
| `g]` | `x` | Move to right "around" | `LazyVim core` |
| `i` | `x` | Inside textobject | `LazyVim core` |
| `il` | `x` | Inside last textobject | `LazyVim core` |
| `in` | `x` | Inside next textobject | `LazyVim core` |
| `j` | `x` | Down | `LazyVim core` |
| `k` | `x` | Up | `LazyVim core` |

## Find and Navigation

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `<Esc>` | `i` | Escape and Clear hlsearch | `LazyVim core` |
| `<Esc>` | `n` | Escape and Clear hlsearch | `LazyVim core` |
| `<leader> ` | `n` | Find Files (Root Dir) | `telescope.nvim` |
| `<leader>E` | `n` | Explorer Snacks (cwd) | `LazyVim core` |
| `<leader>e` | `n` | Explorer (cwd) | `User config` |
| `<leader>fB` | `n` | Buffers (all) | `telescope.nvim` |
| `<leader>fE` | `n` | Explorer Snacks (cwd) | `LazyVim core` |
| `<leader>fF` | `n` | Find Files (cwd) | `telescope.nvim` |
| `<leader>fR` | `n` | Recent (cwd) | `telescope.nvim` |
| `<leader>fT` | `n` | Terminal (cwd) | `LazyVim core` |
| `<leader>fb` | `n` | Buffers | `telescope.nvim` |
| `<leader>fc` | `n` | Find Config File | `telescope.nvim` |
| `<leader>fe` | `n` | Explorer Snacks (root dir) | `LazyVim core` |
| `<leader>ff` | `n` | Find Files (Root Dir) | `telescope.nvim` |
| `<leader>fg` | `n` | Find Files (git-files) | `telescope.nvim` |
| `<leader>fn` | `n` | New File | `LazyVim core` |
| `<leader>fr` | `n` | Replace word under cursor | `User config` |
| `<leader>ft` | `n` | Terminal (Root Dir) | `LazyVim core` |
| `<leader>fx` | `n` | Make current file executable | `User config` |
| `<leader>s/` | `n` | Search History | `telescope.nvim` |
| `<leader>sH` | `n` | Search Highlight Groups | `telescope.nvim` |
| `<leader>ur` | `n` | Redraw / Clear hlsearch / Diff Update | `LazyVim core` |
| `N` | `n` | Previous search result (centered) | `User config` |
| `gx` | `n` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | `LazyVim core` |
| `n` | `n` | Next search result (centered) | `User config` |
| `N` | `o` | Prev Search Result | `LazyVim core` |
| `n` | `o` | Next Search Result | `LazyVim core` |
| `<Esc>` | `s` | Escape and Clear hlsearch | `LazyVim core` |
| `<Esc>` | `v` | Escape and Clear hlsearch | `LazyVim core` |
| `N` | `v` | Prev Search Result | `LazyVim core` |
| `gx` | `v` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | `LazyVim core` |
| `n` | `v` | Next Search Result | `LazyVim core` |
| `N` | `x` | Prev Search Result | `LazyVim core` |
| `gx` | `x` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | `LazyVim core` |
| `n` | `x` | Next Search Result | `LazyVim core` |

## Git

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `<leader>gB` | `n` | Git Browse (open) | `LazyVim core` |
| `<leader>gG` | `n` | Lazygit (cwd) | `LazyVim core` |
| `<leader>gL` | `n` | Git Log (cwd) | `LazyVim core` |
| `<leader>gS` | `n` | Git Stash | `telescope.nvim` |
| `<leader>gY` | `n` | Git Browse (copy) | `LazyVim core` |
| `<leader>gb` | `n` | Git Blame Line | `LazyVim core` |
| `<leader>gc` | `n` | Commits | `telescope.nvim` |
| `<leader>gf` | `n` | Git Current File History | `LazyVim core` |
| `<leader>gg` | `n` | Lazygit (Root Dir) | `LazyVim core` |
| `<leader>gl` | `n` | Commits | `telescope.nvim` |
| `<leader>gs` | `n` | Status | `telescope.nvim` |
| `<leader>gB` | `v` | Git Browse (open) | `LazyVim core` |
| `<leader>gY` | `v` | Git Browse (copy) | `LazyVim core` |
| `<leader>gB` | `x` | Git Browse (open) | `LazyVim core` |
| `<leader>gY` | `x` | Git Browse (copy) | `LazyVim core` |

## Harpoon

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `<leader>1` | `n` | Harpoon: file 1 | `harpoon` |
| `<leader>2` | `n` | Harpoon: file 2 | `harpoon` |
| `<leader>3` | `n` | Harpoon: file 3 | `harpoon` |
| `<leader>4` | `n` | Harpoon: file 4 | `harpoon` |
| `<leader>5` | `n` | Harpoon: file 5 | `harpoon` |
| `<leader>ha` | `n` | Harpoon: add file | `harpoon` |
| `<leader>hh` | `n` | Harpoon: quick menu | `harpoon` |

## Terminal

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `<C-/>` | `n` | Terminal (Root Dir) | `LazyVim core` |
| `<C-/>` | `t` | Terminal (Root Dir) | `LazyVim core` |

## UI and Toggles

| Key | Mode | Action | Plugin |
| --- | --- | --- | --- |
| `<leader>.` | `n` | Toggle Scratch Buffer | `LazyVim core` |
| `<leader>dph` | `n` | Toggle Profiler Highlights | `LazyVim core` |
| `<leader>dpp` | `n` | Toggle Profiler | `LazyVim core` |
| `<leader>uA` | `n` | Toggle Tabline | `LazyVim core` |
| `<leader>uC` | `n` | Colorscheme with Preview | `telescope.nvim` |
| `<leader>uD` | `n` | Toggle Dimming | `LazyVim core` |
| `<leader>uI` | `n` | Inspect Tree | `LazyVim core` |
| `<leader>uL` | `n` | Toggle Relative Number | `LazyVim core` |
| `<leader>uS` | `n` | Toggle Smooth Scroll | `LazyVim core` |
| `<leader>uT` | `n` | Toggle Treesitter Highlight | `LazyVim core` |
| `<leader>uZ` | `n` | Toggle Zoom Mode | `LazyVim core` |
| `<leader>ua` | `n` | Toggle Animations | `LazyVim core` |
| `<leader>ub` | `n` | Toggle Dark Background | `LazyVim core` |
| `<leader>uc` | `n` | Toggle Conceal Level | `LazyVim core` |
| `<leader>ug` | `n` | Toggle Indent Guides | `LazyVim core` |
| `<leader>uh` | `n` | Toggle Inlay Hints | `LazyVim core` |
| `<leader>ui` | `n` | Inspect Pos | `LazyVim core` |
| `<leader>ul` | `n` | Toggle Line Numbers | `LazyVim core` |
| `<leader>un` | `n` | Dismiss All Notifications | `LazyVim core` |
| `<leader>up` | `n` | Toggle Mini Pairs | `LazyVim core` |
| `<leader>us` | `n` | Toggle Spelling | `LazyVim core` |
| `<leader>uw` | `n` | Toggle Wrap | `LazyVim core` |
| `<leader>uz` | `n` | Toggle Zen Mode | `LazyVim core` |
| `<leader>wm` | `n` | Toggle Zoom Mode | `LazyVim core` |
| `gc` | `n` | Toggle comment | `LazyVim core` |
| `gcc` | `n` | Toggle comment line | `LazyVim core` |
| `gc` | `v` | Toggle comment | `LazyVim core` |
| `gc` | `x` | Toggle comment | `LazyVim core` |
