# Complete Neovim mapping inventory

[Reference home](../REFERENCE.md) · [Custom guide](reference-custom.md) · [Inherited guide](reference-defaults.md)

Reviewed 2026-09-24 using Neovim 0.12.5 and installed LazyVim revision 99970099. This appendix is a lookup list; start with the human guides for daily use.

## Scope and notation

Space means your leader. Uppercase and lowercase keys differ. `<C-X>` means Ctrl+x, `<M-x>` means Alt+x, `<D-x>` means Cmd+x, `<CR>` means Enter, and `<BS>` means Backspace. A displayed `<C-X>` is control notation, not an instruction to add Shift. Plain uppercase letters do require Shift.

The tables list all user-facing global mappings captured after VeryLazy and after explicitly loading Telescope, refactoring and Blink. Internal `<Plug>` targets are excluded. Descriptions are supplied by the config/plugin; an expansion is shown when no description exists. The provider column identifies the implementation source, which can be a shared helper (such as Snacks or lazy.nvim), not necessarily the original author of a binding.

This is not a list of every built-in Vim command. Buffer-local LSP and panel mappings only exist in their context; relevant declarations are included below and panel controls are explained in the inherited guide. Key declarations can be overridden, so actual mappings take priority.

## Confirmed shortcuts before and after Telescope loads

| Key / mode | Before those plugins load | After those plugins load |
| --- | --- | --- |
| <code>Space fr</code> / Normal | Find and Replace | Find and Replace |
| <code>Space fR</code> / Normal | Recent (cwd) | Recent Files |
| <code>Space Space</code> / Normal | No-op | Disabled |
| <code>Space rl</code> / Normal | Start live-server in tmux session | Same mapping retained |
| <code>Space rs</code> / Normal | Select Refactor | Same mapping retained |

## Normal mappings

| Keys | Meaning or literal expansion | Implementation provider |
| --- | --- | --- |
| <code>Space Space</code> | Disabled | Personal config |
| <code>Space -</code> | Split Window Below | snacks.nvim |
| <code>Space ,</code> | Switch Buffer | lazy.nvim |
| <code>Space :</code> | Command History | lazy.nvim |
| <code>Space ?</code> | Buffer Keymaps (which-key) | LazyVim |
| <code>Space .</code> | Toggle Scratch Buffer | LazyVim |
| <code>Space /</code> | Grep (Root Dir) | LazyVim |
| <code>Space `</code> | Switch to Other Buffer | snacks.nvim |
| <code>Space &lt;Tab&gt;[</code> | Previous Tab | snacks.nvim |
| <code>Space &lt;Tab&gt;]</code> | Next Tab | snacks.nvim |
| <code>Space &lt;Tab&gt;&lt;Tab&gt;</code> | New Tab | snacks.nvim |
| <code>Space &lt;Tab&gt;d</code> | Close Tab | snacks.nvim |
| <code>Space &lt;Tab&gt;f</code> | First Tab | snacks.nvim |
| <code>Space &lt;Tab&gt;l</code> | Last Tab | snacks.nvim |
| <code>Space &lt;Tab&gt;o</code> | Close Other Tabs | snacks.nvim |
| <code>Space &#124;</code> | Split Window Right | snacks.nvim |
| <code>Space 1</code> | Harpoon to File 1 | lazy.nvim |
| <code>Space 2</code> | Harpoon to File 2 | lazy.nvim |
| <code>Space 3</code> | Harpoon to File 3 | lazy.nvim |
| <code>Space 4</code> | Harpoon to File 4 | lazy.nvim |
| <code>Space 5</code> | Harpoon to File 5 | lazy.nvim |
| <code>Space bb</code> | Switch to Other Buffer | snacks.nvim |
| <code>Space bd</code> | Delete Buffer | LazyVim |
| <code>Space bD</code> | Delete Buffer and Window | snacks.nvim |
| <code>Space bi</code> | Delete Invisible Buffers | LazyVim |
| <code>Space bo</code> | Delete Other Buffers | LazyVim |
| <code>Space cb</code> | diagonistic current file | Personal config |
| <code>Space cd</code> | Line Diagnostics | Neovim runtime |
| <code>Space cf</code> | Format | LazyVim |
| <code>Space cF</code> | Format Injected Langs | lazy.nvim |
| <code>Space cm</code> | Mason | lazy.nvim |
| <code>Space cs</code> | Symbols (Trouble) | lazy.nvim |
| <code>Space cS</code> | LSP references/definitions/... (Trouble) | lazy.nvim |
| <code>Space cu</code> | Toggle UndoTree | lazy.nvim |
| <code>Space d</code> | Expansion: <code>"_d</code> | Personal config |
| <code>Space Da</code> | Run with Args | lazy.nvim |
| <code>Space Db</code> | Toggle Breakpoint | lazy.nvim |
| <code>Space DB</code> | Breakpoint Condition | lazy.nvim |
| <code>Space Dc</code> | Run/Continue | lazy.nvim |
| <code>Space DC</code> | Run to Cursor | lazy.nvim |
| <code>Space De</code> | Eval | lazy.nvim |
| <code>Space Dg</code> | Go to Line (No Execute) | lazy.nvim |
| <code>Space Di</code> | Step Into | lazy.nvim |
| <code>Space Dj</code> | Down | lazy.nvim |
| <code>Space Dk</code> | Up | lazy.nvim |
| <code>Space Dl</code> | Run Last | lazy.nvim |
| <code>Space Do</code> | Step Out | lazy.nvim |
| <code>Space DO</code> | Step Over | lazy.nvim |
| <code>Space DP</code> | Pause | lazy.nvim |
| <code>Space dph</code> | Toggle Profiler Highlights | snacks.nvim |
| <code>Space dpp</code> | Toggle Profiler | snacks.nvim |
| <code>Space dps</code> | Profiler Scratch Buffer | LazyVim |
| <code>Space Dr</code> | Toggle REPL | lazy.nvim |
| <code>Space Ds</code> | Session | lazy.nvim |
| <code>Space Dt</code> | Terminate | lazy.nvim |
| <code>Space Du</code> | Dap UI | lazy.nvim |
| <code>Space Dw</code> | Widgets | lazy.nvim |
| <code>Space e</code> | Open Snacks Explorer | Personal config |
| <code>Space E</code> | Explorer Snacks (cwd) | lazy.nvim |
| <code>Space fb</code> | Buffers | lazy.nvim |
| <code>Space fB</code> | Buffers (all) | lazy.nvim |
| <code>Space fc</code> | Find Config File | LazyVim |
| <code>Space fe</code> | Explorer Snacks (root dir) | LazyVim |
| <code>Space fE</code> | Explorer Snacks (cwd) | LazyVim |
| <code>Space ff</code> | Find Files (Root Dir) | LazyVim |
| <code>Space fF</code> | Find Files from Home (~) | Personal plugin override |
| <code>Space fg</code> | Find Files (git-files) | lazy.nvim |
| <code>Space fn</code> | New File | snacks.nvim |
| <code>Space fr</code> | Find and Replace | Personal config |
| <code>Space fR</code> | Recent Files | Personal config |
| <code>Space fs</code> | Save file  | Personal config |
| <code>Space ft</code> | Terminal (Root Dir) | LazyVim |
| <code>Space fT</code> | Terminal (cwd) | LazyVim |
| <code>Space fx</code> | Make file executable (+x) | Personal config |
| <code>Space gb</code> | Git Blame Line | LazyVim |
| <code>Space gB</code> | Git Browse (open) | LazyVim |
| <code>Space gc</code> | Commits | lazy.nvim |
| <code>Space gf</code> | Git Current File History | LazyVim |
| <code>Space gg</code> | Lazygit (Root Dir) | LazyVim |
| <code>Space gG</code> | Lazygit (cwd) | LazyVim |
| <code>Space gl</code> | Commits | lazy.nvim |
| <code>Space gL</code> | Git Log (cwd) | LazyVim |
| <code>Space go</code> | Toggle mini.diff overlay | LazyVim |
| <code>Space gs</code> | Status | lazy.nvim |
| <code>Space gS</code> | Git Stash | lazy.nvim |
| <code>Space gY</code> | Git Browse (copy) | LazyVim |
| <code>Space ha</code> | Harpoon File | lazy.nvim |
| <code>Space hh</code> | Harpoon Quick Menu | lazy.nvim |
| <code>Space j</code> | Next ERROR LIST | Neovim runtime |
| <code>Space k</code> | Prev ERROR LIST | Neovim runtime |
| <code>Space K</code> | Keywordprg | snacks.nvim |
| <code>Space l</code> | Lazy | snacks.nvim |
| <code>Space L</code> | LazyVim Changelog | LazyVim |
| <code>Space n</code> | Notification History | LazyVim |
| <code>Space p</code> | Callback; inspect with :verbose map | Personal config |
| <code>Space pp</code> | Paste from system clipboard | Personal config |
| <code>Space pv</code> | Expansion: <code>:lua ToggleNetrw()&lt;CR&gt;</code> | Personal config |
| <code>Space qq</code> | Quit All | snacks.nvim |
| <code>Space r</code> | +refactor | lazy.nvim |
| <code>Space rc</code> | Debug Cleanup | LazyVim |
| <code>Space rf</code> | Extract Function | LazyVim |
| <code>Space rF</code> | Extract Function To File | LazyVim |
| <code>Space ri</code> | Inline Variable | LazyVim |
| <code>Space rp</code> | Debug Print Variable | LazyVim |
| <code>Space rP</code> | Debug Print Location | LazyVim |
| <code>Space rr</code> | ▎ Run current file in floating terminal | Personal config |
| <code>Space rs</code> | Select Refactor | LazyVim |
| <code>Space rx</code> | Extract Variable | LazyVim |
| <code>Space S</code> | Select Scratch Buffer | LazyVim |
| <code>Space s"</code> | Registers | lazy.nvim |
| <code>Space s/</code> | Search History | lazy.nvim |
| <code>Space sa</code> | Auto Commands | lazy.nvim |
| <code>Space sb</code> | Buffer Lines | lazy.nvim |
| <code>Space sc</code> | Command History | lazy.nvim |
| <code>Space sC</code> | Commands | lazy.nvim |
| <code>Space sd</code> | Diagnostics | lazy.nvim |
| <code>Space sD</code> | Buffer Diagnostics | lazy.nvim |
| <code>Space sg</code> | Grep (Root Dir) | LazyVim |
| <code>Space sG</code> | Grep (cwd) | LazyVim |
| <code>Space sh</code> | Help Pages | lazy.nvim |
| <code>Space sH</code> | Search Highlight Groups | lazy.nvim |
| <code>Space sj</code> | Jumplist | lazy.nvim |
| <code>Space sk</code> | Key Maps | lazy.nvim |
| <code>Space sl</code> | Location List | lazy.nvim |
| <code>Space sm</code> | Jump to Mark | lazy.nvim |
| <code>Space sM</code> | Man Pages | lazy.nvim |
| <code>Space sn</code> | +noice | lazy.nvim |
| <code>Space sna</code> | Noice All | LazyVim |
| <code>Space snd</code> | Dismiss All | LazyVim |
| <code>Space snh</code> | Noice History | LazyVim |
| <code>Space snl</code> | Noice Last Message | LazyVim |
| <code>Space snt</code> | Noice Picker (Telescope/FzfLua) | LazyVim |
| <code>Space so</code> | Options | lazy.nvim |
| <code>Space sq</code> | Quickfix List | lazy.nvim |
| <code>Space sR</code> | Resume | lazy.nvim |
| <code>Space ss</code> | Goto Symbol | LazyVim |
| <code>Space sS</code> | Goto Symbol (Workspace) | LazyVim |
| <code>Space sw</code> | Word (Root Dir) | LazyVim |
| <code>Space sW</code> | Word (cwd) | LazyVim |
| <code>Space tt</code> | ▎ Open floating terminal | Personal config |
| <code>Space ua</code> | Toggle Animations | snacks.nvim |
| <code>Space uA</code> | Toggle Tabline | snacks.nvim |
| <code>Space ub</code> | Toggle Dark Background | snacks.nvim |
| <code>Space uc</code> | Toggle Conceal Level | snacks.nvim |
| <code>Space uC</code> | Colorscheme with Preview | LazyVim |
| <code>Space ud</code> | Toggle Diagnostics | snacks.nvim |
| <code>Space uD</code> | Toggle Dimming | snacks.nvim |
| <code>Space uf</code> | Toggle Auto Format (Global) | snacks.nvim |
| <code>Space uF</code> | Toggle Auto Format (Buffer) | snacks.nvim |
| <code>Space ug</code> | Toggle Indent Guides | snacks.nvim |
| <code>Space uG</code> | Toggle Mini Diff Signs | snacks.nvim |
| <code>Space uh</code> | Toggle Inlay Hints | snacks.nvim |
| <code>Space ui</code> | Inspect Pos | Neovim runtime |
| <code>Space uI</code> | Inspect Tree | LazyVim |
| <code>Space ul</code> | Toggle Line Numbers | snacks.nvim |
| <code>Space uL</code> | Toggle Relative Number | snacks.nvim |
| <code>Space un</code> | Dismiss All Notifications | LazyVim |
| <code>Space up</code> | Toggle Mini Pairs | snacks.nvim |
| <code>Space ur</code> | Redraw / Clear hlsearch / Diff Update | snacks.nvim |
| <code>Space us</code> | Toggle Spelling | snacks.nvim |
| <code>Space uS</code> | Toggle Smooth Scroll | snacks.nvim |
| <code>Space uT</code> | Toggle Treesitter Highlight | snacks.nvim |
| <code>Space uw</code> | Toggle Wrap | snacks.nvim |
| <code>Space uz</code> | Toggle Zen Mode | snacks.nvim |
| <code>Space uZ</code> | Toggle Zoom Mode | snacks.nvim |
| <code>Space wd</code> | Delete Window | snacks.nvim |
| <code>Space wm</code> | Toggle Zoom Mode | snacks.nvim |
| <code>Space xl</code> | Location List | LazyVim |
| <code>Space xL</code> | Location List (Trouble) | lazy.nvim |
| <code>Space xq</code> | Quickfix List | LazyVim |
| <code>Space xQ</code> | Quickfix List (Trouble) | lazy.nvim |
| <code>Space xx</code> | Diagnostics (Trouble) | lazy.nvim |
| <code>Space xX</code> | Buffer Diagnostics (Trouble) | lazy.nvim |
| <code>Space y</code> | Yank to system clipboard | Personal config |
| <code>Space Y</code> | Expansion: <code>"+Y</code> | Personal config |
| <code>[ </code> | Add empty line above cursor | Neovim runtime |
| <code>[%</code> | Expansion: <code>&lt;Plug&gt;(MatchitNormalMultiBackward)</code> | Neovim runtime |
| <code>[&lt;C-L&gt;</code> | :lpfile | Neovim runtime |
| <code>[&lt;C-Q&gt;</code> | :cpfile | Neovim runtime |
| <code>[&lt;C-T&gt;</code> | :ptprevious | Neovim runtime |
| <code>[a</code> | :previous | Neovim runtime |
| <code>[A</code> | :rewind | Neovim runtime |
| <code>[b</code> | Prev Buffer | snacks.nvim |
| <code>[B</code> | :brewind | Neovim runtime |
| <code>[d</code> | Prev Diagnostic | LazyVim |
| <code>[D</code> | Jump to the first diagnostic in the current buffer | Neovim runtime |
| <code>[e</code> | Prev Error | LazyVim |
| <code>[h</code> | Previous hunk | mini.diff |
| <code>[H</code> | First hunk | mini.diff |
| <code>[i</code> | jump to top edge of scope | snacks.nvim |
| <code>[l</code> | :lprevious | Neovim runtime |
| <code>[L</code> | :lrewind | Neovim runtime |
| <code>[q</code> | Previous Trouble/Quickfix Item | LazyVim |
| <code>[Q</code> | :crewind | Neovim runtime |
| <code>[t</code> | :tprevious | Neovim runtime |
| <code>[T</code> | :trewind | Neovim runtime |
| <code>[w</code> | Prev Warning | LazyVim |
| <code>] </code> | Add empty line below cursor | Neovim runtime |
| <code>]%</code> | Expansion: <code>&lt;Plug&gt;(MatchitNormalMultiForward)</code> | Neovim runtime |
| <code>]&lt;C-L&gt;</code> | :lnfile | Neovim runtime |
| <code>]&lt;C-Q&gt;</code> | :cnfile | Neovim runtime |
| <code>]&lt;C-T&gt;</code> | :ptnext | Neovim runtime |
| <code>]a</code> | :next | Neovim runtime |
| <code>]A</code> | :last | Neovim runtime |
| <code>]b</code> | Next Buffer | snacks.nvim |
| <code>]B</code> | :blast | Neovim runtime |
| <code>]d</code> | Next Diagnostic | LazyVim |
| <code>]D</code> | Jump to the last diagnostic in the current buffer | Neovim runtime |
| <code>]e</code> | Next Error | LazyVim |
| <code>]h</code> | Next hunk | mini.diff |
| <code>]H</code> | Last hunk | mini.diff |
| <code>]i</code> | jump to bottom edge of scope | snacks.nvim |
| <code>]l</code> | :lnext | Neovim runtime |
| <code>]L</code> | :llast | Neovim runtime |
| <code>]q</code> | Next Trouble/Quickfix Item | LazyVim |
| <code>]Q</code> | :clast | Neovim runtime |
| <code>]t</code> | :tnext | Neovim runtime |
| <code>]T</code> | :tlast | Neovim runtime |
| <code>]w</code> | Next Warning | LazyVim |
| <code>&amp;</code> | :help &amp;-default | Neovim runtime |
| <code>%</code> | Expansion: <code>&lt;Plug&gt;(MatchitNormalForward)</code> | Neovim runtime |
| <code>&lt;BS&gt;</code> | Expansion: <code>&lt;C-U&gt;zz</code> | Personal config |
| <code>&lt;C-_&gt;</code> | which_key_ignore | LazyVim |
| <code>&lt;C-/&gt;</code> | Terminal (Root Dir) | LazyVim |
| <code>&lt;C-A&gt;</code> | Expansion: <code>ggVG</code> | Personal config |
| <code>&lt;C-B&gt;</code> | Scroll Backward | LazyVim |
| <code>&lt;C-D&gt;</code> | Expansion: <code>&lt;C-D&gt;zz</code> | Personal config |
| <code>&lt;C-Down&gt;</code> | Decrease Height | Personal config |
| <code>&lt;C-F&gt;</code> | Smart Tmux Sessionizer | Personal config |
| <code>&lt;C-H&gt;</code> | Go to Left Window | snacks.nvim |
| <code>&lt;C-J&gt;</code> | Go to Lower Window | snacks.nvim |
| <code>&lt;C-K&gt;</code> | Toggle LSP Signature | Personal config |
| <code>&lt;C-L&gt;</code> | Go to Right Window | snacks.nvim |
| <code>&lt;C-Left&gt;</code> | Decrease Width | Personal config |
| <code>&lt;C-Q&gt;</code> | Expansion: <code>:q&lt;CR&gt;</code> | Personal config |
| <code>&lt;C-Right&gt;</code> | Increase Width | Personal config |
| <code>&lt;C-S&gt;</code> | Save File | snacks.nvim |
| <code>&lt;C-U&gt;</code> | Expansion: <code>&lt;C-U&gt;zz</code> | Personal config |
| <code>&lt;C-Up&gt;</code> | Increase Height | Personal config |
| <code>&lt;C-W&gt; </code> | Window Hydra Mode (which-key) | LazyVim |
| <code>&lt;C-W&gt;&lt;C-D&gt;</code> | Show diagnostics under the cursor | Neovim runtime |
| <code>&lt;C-W&gt;d</code> | Show diagnostics under the cursor | Neovim runtime |
| <code>&lt;C-Y&gt;</code> | Expansion: <code>&lt;C-R&gt;</code> | Personal config |
| <code>&lt;CR&gt;</code> | Expansion: <code>&lt;C-D&gt;zz</code> | Personal config |
| <code>&lt;D-s&gt;</code> | Save file (CMD+S workaround) | Personal config |
| <code>&lt;Down&gt;</code> | Down | snacks.nvim |
| <code>&lt;Esc&gt;</code> | Escape and Clear hlsearch | LazyVim |
| <code>&lt;M-j&gt;</code> | Move Down | snacks.nvim |
| <code>&lt;M-k&gt;</code> | Move Up | snacks.nvim |
| <code>&lt;Up&gt;</code> | Up | snacks.nvim |
| <code>g[</code> | Move to left "around" | mini.ai |
| <code>g]</code> | Move to right "around" | mini.ai |
| <code>g%</code> | Expansion: <code>&lt;Plug&gt;(MatchitNormalBackward)</code> | Neovim runtime |
| <code>gc</code> | Toggle comment | Neovim runtime |
| <code>gcc</code> | Toggle comment line | Neovim runtime |
| <code>gco</code> | Add Comment Below | snacks.nvim |
| <code>gcO</code> | Add Comment Above | snacks.nvim |
| <code>gh</code> | Apply hunks | mini.diff |
| <code>gH</code> | Reset hunks | mini.diff |
| <code>gO</code> | vim.lsp.buf.document_symbol() | Neovim runtime |
| <code>gra</code> | vim.lsp.buf.code_action() | Neovim runtime |
| <code>gri</code> | vim.lsp.buf.implementation() | Neovim runtime |
| <code>grn</code> | vim.lsp.buf.rename() | Neovim runtime |
| <code>grr</code> | vim.lsp.buf.references() | Neovim runtime |
| <code>grt</code> | vim.lsp.buf.type_definition() | Neovim runtime |
| <code>grx</code> | vim.lsp.codelens.run() | Neovim runtime |
| <code>gx</code> | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | Neovim runtime |
| <code>H</code> | Prev Buffer | snacks.nvim |
| <code>j</code> | Down | snacks.nvim |
| <code>J</code> | Expansion: <code>mzJ`z</code> | Personal config |
| <code>k</code> | Up | snacks.nvim |
| <code>L</code> | Next Buffer | snacks.nvim |
| <code>n</code> | Expansion: <code>nzzzv</code> | Personal config |
| <code>N</code> | Expansion: <code>Nzzzv</code> | Personal config |
| <code>Q</code> | Callback; inspect with :verbose map | Personal config |
| <code>Y</code> | :help Y-default | Neovim runtime |

## Visual mappings

| Keys | Meaning or literal expansion | Implementation provider |
| --- | --- | --- |
| <code>Space cf</code> | Format | LazyVim |
| <code>Space cF</code> | Format Injected Langs | lazy.nvim |
| <code>Space d</code> | Expansion: <code>"_d</code> | Personal config |
| <code>Space De</code> | Eval | lazy.nvim |
| <code>Space fs</code> | Save file  | Personal config |
| <code>Space gB</code> | Git Browse (open) | LazyVim |
| <code>Space gY</code> | Git Browse (copy) | LazyVim |
| <code>Space pn</code> | Paste without storing | Personal config |
| <code>Space pp</code> | Paste from system clipboard | Personal config |
| <code>Space r</code> | +refactor | lazy.nvim |
| <code>Space rf</code> | Extract Function | LazyVim |
| <code>Space rF</code> | Extract Function To File | LazyVim |
| <code>Space ri</code> | Inline Variable | LazyVim |
| <code>Space rp</code> | Debug Print Variable | LazyVim |
| <code>Space rs</code> | Select Refactor | LazyVim |
| <code>Space rx</code> | Extract Variable | LazyVim |
| <code>Space sw</code> | Selection (Root Dir) | LazyVim |
| <code>Space sW</code> | Selection (cwd) | LazyVim |
| <code>Space y</code> | Yank to system clipboard | Personal config |
| <code>[%</code> | Expansion: <code>&lt;Plug&gt;(MatchitVisualMultiBackward)</code> | Neovim runtime |
| <code>[h</code> | Previous hunk | mini.diff |
| <code>[H</code> | First hunk | mini.diff |
| <code>[i</code> | jump to top edge of scope | snacks.nvim |
| <code>[n</code> | Select previous node | Neovim runtime |
| <code>[N</code> | Select previous sibling node | Neovim runtime |
| <code>]%</code> | Expansion: <code>&lt;Plug&gt;(MatchitVisualMultiForward)</code> | Neovim runtime |
| <code>]h</code> | Next hunk | mini.diff |
| <code>]H</code> | Last hunk | mini.diff |
| <code>]i</code> | jump to bottom edge of scope | snacks.nvim |
| <code>]n</code> | Select next node | Neovim runtime |
| <code>]N</code> | Select next sibling node | Neovim runtime |
| <code>@</code> | :help v_@-default | Neovim runtime |
| <code>*</code> | :help v_star-default | Neovim runtime |
| <code>#</code> | :help v_#-default | Neovim runtime |
| <code>%</code> | Expansion: <code>&lt;Plug&gt;(MatchitVisualForward)</code> | Neovim runtime |
| <code>&lt;BS&gt;</code> | Expansion: <code>16k</code> | Personal config |
| <code>&lt;C-S&gt;</code> | Save File | snacks.nvim |
| <code>&lt;CR&gt;</code> | Expansion: <code>&lt;C-D&gt;zz</code> | Personal config |
| <code>&lt;Down&gt;</code> | Down | snacks.nvim |
| <code>&lt;lt&gt;</code> | Expansion: <code>&lt;lt&gt;gv</code> | snacks.nvim |
| <code>&lt;M-j&gt;</code> | Move Down | snacks.nvim |
| <code>&lt;M-k&gt;</code> | Move Up | snacks.nvim |
| <code>&lt;Up&gt;</code> | Up | snacks.nvim |
| <code>&gt;</code> | Expansion: <code>&gt;gv</code> | snacks.nvim |
| <code>a</code> | Around textobject | mini.ai |
| <code>a%</code> | Expansion: <code>&lt;Plug&gt;(MatchitVisualTextObject)</code> | Neovim runtime |
| <code>ai</code> | full scope | snacks.nvim |
| <code>al</code> | Around last textobject | mini.ai |
| <code>an</code> | Around next textobject | mini.ai |
| <code>g[</code> | Move to left "around" | mini.ai |
| <code>g]</code> | Move to right "around" | mini.ai |
| <code>g%</code> | Expansion: <code>&lt;Plug&gt;(MatchitVisualBackward)</code> | Neovim runtime |
| <code>gc</code> | Toggle comment | Neovim runtime |
| <code>gh</code> | Apply hunks | mini.diff |
| <code>gH</code> | Reset hunks | mini.diff |
| <code>gra</code> | vim.lsp.buf.code_action() | Neovim runtime |
| <code>gx</code> | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | Neovim runtime |
| <code>i</code> | Inside textobject | mini.ai |
| <code>ii</code> | inner scope | snacks.nvim |
| <code>il</code> | Inside last textobject | mini.ai |
| <code>in</code> | Inside next textobject | mini.ai |
| <code>j</code> | Down | snacks.nvim |
| <code>J</code> | Expansion: <code>:m '&gt;+1&lt;CR&gt;gv=gv</code> | Personal config |
| <code>k</code> | Up | snacks.nvim |
| <code>K</code> | Expansion: <code>:m '&lt;lt&gt;-2&lt;CR&gt;gv=gv</code> | Personal config |
| <code>n</code> | Next Search Result | snacks.nvim |
| <code>N</code> | Prev Search Result | snacks.nvim |
| <code>Q</code> | :help v_Q-default | Neovim runtime |

## Insert mappings

| Keys | Meaning or literal expansion | Implementation provider |
| --- | --- | --- |
| <code>,</code> | Expansion: <code>,&lt;C-G&gt;u</code> | snacks.nvim |
| <code>;</code> | Expansion: <code>;&lt;C-G&gt;u</code> | snacks.nvim |
| <code>.</code> | Expansion: <code>.&lt;C-G&gt;u</code> | snacks.nvim |
| <code>'</code> | Closeopen action for "''" pair | mini.pairs |
| <code>"</code> | Closeopen action for '""' pair | mini.pairs |
| <code>(</code> | Open action for "()" pair | mini.pairs |
| <code>)</code> | Close action for "()" pair | mini.pairs |
| <code>[</code> | Open action for "[]" pair | mini.pairs |
| <code>]</code> | Close action for "[]" pair | mini.pairs |
| <code>{</code> | Open action for "{}" pair | mini.pairs |
| <code>}</code> | Close action for "{}" pair | mini.pairs |
| <code>`</code> | Closeopen action for "``" pair | mini.pairs |
| <code>&lt;BS&gt;</code> | MiniPairs &lt;BS&gt; | mini.pairs |
| <code>&lt;C-A&gt;</code> | Expansion: <code>&lt;Esc&gt;ggVG</code> | Personal config |
| <code>&lt;C-B&gt;</code> | Scroll Backward | LazyVim |
| <code>&lt;C-F&gt;</code> | Scroll Forward | LazyVim |
| <code>&lt;C-S&gt;</code> | Save File | snacks.nvim |
| <code>&lt;C-U&gt;</code> | :help i_CTRL-U-default | Neovim runtime |
| <code>&lt;C-W&gt;</code> | :help i_CTRL-W-default | Neovim runtime |
| <code>&lt;CR&gt;</code> | MiniPairs &lt;CR&gt; | mini.pairs |
| <code>&lt;Esc&gt;</code> | Escape and Clear hlsearch | LazyVim |
| <code>&lt;M-j&gt;</code> | Move Down | snacks.nvim |
| <code>&lt;M-k&gt;</code> | Move Up | snacks.nvim |
| <code>&lt;S-Tab&gt;</code> | vim.snippet.jump if active, otherwise &lt;S-Tab&gt; | Neovim runtime |
| <code>&lt;Tab&gt;</code> | vim.snippet.jump if active, otherwise &lt;Tab&gt; | Neovim runtime |

## Select mappings

| Keys | Meaning or literal expansion | Implementation provider |
| --- | --- | --- |
| <code>Space d</code> | Expansion: <code>"_d</code> | Personal config |
| <code>Space fs</code> | Save file  | Personal config |
| <code>Space pp</code> | Paste from system clipboard | Personal config |
| <code>Space y</code> | Yank to system clipboard | Personal config |
| <code>&lt;C-B&gt;</code> | Scroll Backward | LazyVim |
| <code>&lt;C-F&gt;</code> | Scroll Forward | LazyVim |
| <code>&lt;C-S&gt;</code> | Save File | snacks.nvim |
| <code>&lt;CR&gt;</code> | Expansion: <code>&lt;C-D&gt;zz</code> | Personal config |
| <code>&lt;Esc&gt;</code> | Escape and Clear hlsearch | LazyVim |
| <code>&lt;M-j&gt;</code> | Move Down | snacks.nvim |
| <code>&lt;M-k&gt;</code> | Move Up | snacks.nvim |
| <code>&lt;S-Tab&gt;</code> | vim.snippet.jump if active, otherwise &lt;S-Tab&gt; | Neovim runtime |
| <code>&lt;Tab&gt;</code> | vim.snippet.jump if active, otherwise &lt;Tab&gt; | Neovim runtime |
| <code>J</code> | Expansion: <code>:m '&gt;+1&lt;CR&gt;gv=gv</code> | Personal config |
| <code>K</code> | Expansion: <code>:m '&lt;lt&gt;-2&lt;CR&gt;gv=gv</code> | Personal config |

## Operator-pending mappings

| Keys | Meaning or literal expansion | Implementation provider |
| --- | --- | --- |
| <code>[%</code> | Expansion: <code>&lt;Plug&gt;(MatchitOperationMultiBackward)</code> | Neovim runtime |
| <code>[h</code> | Previous hunk | mini.diff |
| <code>[H</code> | First hunk | mini.diff |
| <code>[i</code> | jump to top edge of scope | snacks.nvim |
| <code>]%</code> | Expansion: <code>&lt;Plug&gt;(MatchitOperationMultiForward)</code> | Neovim runtime |
| <code>]h</code> | Next hunk | mini.diff |
| <code>]H</code> | Last hunk | mini.diff |
| <code>]i</code> | jump to bottom edge of scope | snacks.nvim |
| <code>%</code> | Expansion: <code>&lt;Plug&gt;(MatchitOperationForward)</code> | Neovim runtime |
| <code>a</code> | Around textobject | mini.ai |
| <code>ai</code> | full scope | snacks.nvim |
| <code>al</code> | Around last textobject | mini.ai |
| <code>an</code> | Around next textobject | mini.ai |
| <code>g[</code> | Move to left "around" | mini.ai |
| <code>g]</code> | Move to right "around" | mini.ai |
| <code>g%</code> | Expansion: <code>&lt;Plug&gt;(MatchitOperationBackward)</code> | Neovim runtime |
| <code>gc</code> | Comment textobject | Neovim runtime |
| <code>gh</code> | Hunk range textobject | mini.diff |
| <code>i</code> | Inside textobject | mini.ai |
| <code>ii</code> | inner scope | snacks.nvim |
| <code>il</code> | Inside last textobject | mini.ai |
| <code>in</code> | Inside next textobject | mini.ai |
| <code>n</code> | Next Search Result | snacks.nvim |
| <code>N</code> | Prev Search Result | snacks.nvim |

## Terminal mappings

| Keys | Meaning or literal expansion | Implementation provider |
| --- | --- | --- |
| <code>&lt;C-_&gt;</code> | which_key_ignore | LazyVim |
| <code>&lt;C-/&gt;</code> | Terminal (Root Dir) | LazyVim |

## Plugin shortcut declarations

These include lazy triggers and filetype-specific declarations, even when a global custom mapping currently wins. For example, the Snacks root explorer declaration is overridden by your direct Space e callback. Repeated declarations show merged plugin specifications, not additional keys to press.

| Plugin | Key | Mode / context | Meaning |
| --- | --- | --- | --- |
| conform.nvim | <code>Space cF</code> | n,x | Format Injected Langs |
| harpoon | <code>Space 1</code> | n | Harpoon to File 1 |
| harpoon | <code>Space 2</code> | n | Harpoon to File 2 |
| harpoon | <code>Space 3</code> | n | Harpoon to File 3 |
| harpoon | <code>Space 4</code> | n | Harpoon to File 4 |
| harpoon | <code>Space 5</code> | n | Harpoon to File 5 |
| harpoon | <code>Space H</code> | n | Disabled |
| harpoon | <code>Space ha</code> | n | Harpoon File |
| harpoon | <code>Space hh</code> | n | Harpoon Quick Menu |
| mason.nvim | <code>Space cm</code> | n | Mason |
| mini.diff | <code>Space go</code> | n | Toggle mini.diff overlay |
| noice.nvim | <code>&lt;c-b&gt;</code> | i,n,s | Scroll Backward |
| noice.nvim | <code>&lt;c-f&gt;</code> | i,n,s | Scroll Forward |
| noice.nvim | <code>Space sn</code> | n | +noice |
| noice.nvim | <code>Space sna</code> | n | Noice All |
| noice.nvim | <code>Space snd</code> | n | Dismiss All |
| noice.nvim | <code>Space snh</code> | n | Noice History |
| noice.nvim | <code>Space snl</code> | n | Noice Last Message |
| noice.nvim | <code>Space snt</code> | n | Noice Picker (Telescope/FzfLua) |
| noice.nvim | <code>&lt;S-Enter&gt;</code> | c | Redirect Cmdline |
| nvim-dap-python | <code>Space DPc</code> | n / python | Debug Class |
| nvim-dap-python | <code>Space DPt</code> | n / python | Debug Method |
| nvim-dap-ui | <code>Space De</code> | n,x | Eval |
| nvim-dap-ui | <code>Space Du</code> | n | Dap UI |
| nvim-dap | <code>Space Da</code> | n | Run with Args |
| nvim-dap | <code>Space Db</code> | n | Toggle Breakpoint |
| nvim-dap | <code>Space DB</code> | n | Breakpoint Condition |
| nvim-dap | <code>Space Dc</code> | n | Run/Continue |
| nvim-dap | <code>Space DC</code> | n | Run to Cursor |
| nvim-dap | <code>Space Dg</code> | n | Go to Line (No Execute) |
| nvim-dap | <code>Space Di</code> | n | Step Into |
| nvim-dap | <code>Space Dj</code> | n | Down |
| nvim-dap | <code>Space Dk</code> | n | Up |
| nvim-dap | <code>Space Dl</code> | n | Run Last |
| nvim-dap | <code>Space Do</code> | n | Step Out |
| nvim-dap | <code>Space DO</code> | n | Step Over |
| nvim-dap | <code>Space DP</code> | n | Pause |
| nvim-dap | <code>Space Dr</code> | n | Toggle REPL |
| nvim-dap | <code>Space Ds</code> | n | Session |
| nvim-dap | <code>Space Dt</code> | n | Terminate |
| nvim-dap | <code>Space Dw</code> | n | Widgets |
| refactoring.nvim | <code>Space r</code> | n,x | +refactor |
| refactoring.nvim | <code>Space rc</code> | n | Debug Cleanup |
| refactoring.nvim | <code>Space rf</code> | n,x | Extract Function |
| refactoring.nvim | <code>Space rF</code> | n,x | Extract Function To File |
| refactoring.nvim | <code>Space ri</code> | n,x | Inline Variable |
| refactoring.nvim | <code>Space rp</code> | n,x | Debug Print Variable |
| refactoring.nvim | <code>Space rP</code> | n | Debug Print Location |
| refactoring.nvim | <code>Space rs</code> | n,x | Select Refactor |
| refactoring.nvim | <code>Space rx</code> | n,x | Extract Variable |
| snacks.nvim | <code>Space .</code> | n | Toggle Scratch Buffer |
| snacks.nvim | <code>Space dps</code> | n | Profiler Scratch Buffer |
| snacks.nvim | <code>Space e</code> | n | Explorer Snacks (root dir) |
| snacks.nvim | <code>Space E</code> | n | Explorer Snacks (cwd) |
| snacks.nvim | <code>Space fe</code> | n | Explorer Snacks (root dir) |
| snacks.nvim | <code>Space fE</code> | n | Explorer Snacks (cwd) |
| snacks.nvim | <code>Space n</code> | n | Notification History |
| snacks.nvim | <code>Space S</code> | n | Select Scratch Buffer |
| snacks.nvim | <code>Space un</code> | n | Dismiss All Notifications |
| telescope.nvim | <code>Space ,</code> | n | Switch Buffer |
| telescope.nvim | <code>Space :</code> | n | Command History |
| telescope.nvim | <code>Space /</code> | n | Grep (Root Dir) |
| telescope.nvim | <code>Space &lt;space&gt;</code> | n | Find Files (Root Dir) |
| telescope.nvim | <code>Space fb</code> | n | Buffers |
| telescope.nvim | <code>Space fB</code> | n | Buffers (all) |
| telescope.nvim | <code>Space fc</code> | n | Find Config File |
| telescope.nvim | <code>Space ff</code> | n | Find Files (Root Dir) |
| telescope.nvim | <code>Space fF</code> | n | Find Files (cwd) |
| telescope.nvim | <code>Space fF</code> | n | Find Files from Home (~) |
| telescope.nvim | <code>Space fg</code> | n | Find Files (git-files) |
| telescope.nvim | <code>Space fr</code> | n | Recent |
| telescope.nvim | <code>Space fR</code> | n | Recent (cwd) |
| telescope.nvim | <code>Space gc</code> | n | Commits |
| telescope.nvim | <code>Space gl</code> | n | Commits |
| telescope.nvim | <code>Space gs</code> | n | Status |
| telescope.nvim | <code>Space gS</code> | n | Git Stash |
| telescope.nvim | <code>Space s"</code> | n | Registers |
| telescope.nvim | <code>Space s/</code> | n | Search History |
| telescope.nvim | <code>Space sa</code> | n | Auto Commands |
| telescope.nvim | <code>Space sb</code> | n | Buffer Lines |
| telescope.nvim | <code>Space sc</code> | n | Command History |
| telescope.nvim | <code>Space sC</code> | n | Commands |
| telescope.nvim | <code>Space sd</code> | n | Diagnostics |
| telescope.nvim | <code>Space sD</code> | n | Buffer Diagnostics |
| telescope.nvim | <code>Space sg</code> | n | Grep (Root Dir) |
| telescope.nvim | <code>Space sG</code> | n | Grep (cwd) |
| telescope.nvim | <code>Space sh</code> | n | Help Pages |
| telescope.nvim | <code>Space sH</code> | n | Search Highlight Groups |
| telescope.nvim | <code>Space sj</code> | n | Jumplist |
| telescope.nvim | <code>Space sk</code> | n | Key Maps |
| telescope.nvim | <code>Space sl</code> | n | Location List |
| telescope.nvim | <code>Space sm</code> | n | Jump to Mark |
| telescope.nvim | <code>Space sM</code> | n | Man Pages |
| telescope.nvim | <code>Space so</code> | n | Options |
| telescope.nvim | <code>Space sq</code> | n | Quickfix List |
| telescope.nvim | <code>Space sR</code> | n | Resume |
| telescope.nvim | <code>Space ss</code> | n | Goto Symbol |
| telescope.nvim | <code>Space sS</code> | n | Goto Symbol (Workspace) |
| telescope.nvim | <code>Space sw</code> | n | Word (Root Dir) |
| telescope.nvim | <code>Space sw</code> | x | Selection (Root Dir) |
| telescope.nvim | <code>Space sW</code> | n | Word (cwd) |
| telescope.nvim | <code>Space sW</code> | x | Selection (cwd) |
| telescope.nvim | <code>Space uC</code> | n | Colorscheme with Preview |
| trouble.nvim | <code>[q</code> | n | Previous Trouble/Quickfix Item |
| trouble.nvim | <code>]q</code> | n | Next Trouble/Quickfix Item |
| trouble.nvim | <code>Space cs</code> | n | Symbols (Trouble) |
| trouble.nvim | <code>Space cS</code> | n | LSP references/definitions/... (Trouble) |
| trouble.nvim | <code>Space xL</code> | n | Location List (Trouble) |
| trouble.nvim | <code>Space xQ</code> | n | Quickfix List (Trouble) |
| trouble.nvim | <code>Space xx</code> | n | Diagnostics (Trouble) |
| trouble.nvim | <code>Space xX</code> | n | Buffer Diagnostics (Trouble) |
| undotree | <code>Space cu</code> | n | Toggle UndoTree |
| venv-selector.nvim | <code>Space cv</code> | n / python | Select VirtualEnv |
| which-key.nvim | <code>&lt;c-w&gt;&lt;space&gt;</code> | n | Window Hydra Mode (which-key) |
| which-key.nvim | <code>Space ?</code> | n | Buffer Keymaps (which-key) |

## Language-server mappings

Declared in the resolved LSP options; attachment and capabilities decide whether each mapping is installed. Server-specific mappings can replace the common ones. No language server was started solely to produce this table.

| Server / context | Key | Modes | Meaning / requirement |
| --- | --- | --- | --- |
| Any supporting server | <code>Space cl</code> | n | Lsp Info |
| Any supporting server | <code>gd</code> | n | Goto Definition (needs definition) |
| Any supporting server | <code>gr</code> | n | References |
| Any supporting server | <code>gI</code> | n | Goto Implementation |
| Any supporting server | <code>gy</code> | n | Goto T[y]pe Definition |
| Any supporting server | <code>gD</code> | n | Goto Declaration |
| Any supporting server | <code>K</code> | n | Hover |
| Any supporting server | <code>gK</code> | n | Signature Help (needs signatureHelp) |
| Any supporting server | <code>&lt;c-k&gt;</code> | i | Signature Help (needs signatureHelp) |
| Any supporting server | <code>Space ca</code> | n,x | Code Action (needs codeAction) |
| Any supporting server | <code>Space cc</code> | n,x | Run Codelens (needs codeLens) |
| Any supporting server | <code>Space cC</code> | n | Refresh &amp; Display Codelens (needs codeLens) |
| Any supporting server | <code>Space cR</code> | n | Rename File (needs workspace/didRenameFiles, workspace/willRenameFiles) |
| Any supporting server | <code>Space cr</code> | n | Rename (needs rename) |
| Any supporting server | <code>Space cA</code> | n | Source Action (needs codeAction) |
| Any supporting server | <code>]]</code> | n | Next Reference (needs documentHighlight) |
| Any supporting server | <code>[[</code> | n | Prev Reference (needs documentHighlight) |
| Any supporting server | <code>&lt;a-n&gt;</code> | n | Next Reference (needs documentHighlight) |
| Any supporting server | <code>&lt;a-p&gt;</code> | n | Prev Reference (needs documentHighlight) |
| Any supporting server | <code>Space co</code> | n | Organize Imports (needs codeAction) |
| Any supporting server | <code>gd</code> | n | Goto Definition (needs definition) |
| Any supporting server | <code>gr</code> | n | References |
| Any supporting server | <code>gI</code> | n | Goto Implementation |
| Any supporting server | <code>gy</code> | n | Goto T[y]pe Definition |
| vtsls | <code>gD</code> | n | Goto Source Definition |
| vtsls | <code>gR</code> | n | File References |
| vtsls | <code>Space cM</code> | n | Add missing imports |
| vtsls | <code>Space cD</code> | n | Fix all diagnostics |
| vtsls | <code>Space cV</code> | n | Select TS workspace version |
| clangd | <code>Space ch</code> | n | Switch Source/Header (C/C++) |

## Blink Insert-mode completion

| Key | Ordered actions |
| --- | --- |
| <code>preset</code> | none |
| <code>&lt;C-space&gt;</code> | No action |
| <code>&lt;C-e&gt;</code> | cancel → fallback |
| <code>&lt;C-n&gt;</code> | select_next |
| <code>&lt;C-p&gt;</code> | select_prev → fallback |
| <code>&lt;C-y&gt;</code> | accept → fallback |
| <code>&lt;Tab&gt;</code> | &lt;function&gt; → fallback |

## Treesitter textobject movement

Filetype/parser-dependent; these declarations may override built-in argument-list motions with the same spelling.

| Key | Action | Syntax target |
| --- | --- | --- |
| <code>[A</code> | goto previous end | <code>@parameter.inner</code> |
| <code>[C</code> | goto previous end | <code>@class.outer</code> |
| <code>[F</code> | goto previous end | <code>@function.outer</code> |
| <code>]C</code> | goto next end | <code>@class.outer</code> |
| <code>]F</code> | goto next end | <code>@function.outer</code> |
| <code>]A</code> | goto next end | <code>@parameter.inner</code> |
| <code>]c</code> | goto next start | <code>@class.outer</code> |
| <code>]f</code> | goto next start | <code>@function.outer</code> |
| <code>]a</code> | goto next start | <code>@parameter.inner</code> |
| <code>[a</code> | goto previous start | <code>@parameter.inner</code> |
| <code>[c</code> | goto previous start | <code>@class.outer</code> |
| <code>[f</code> | goto previous start | <code>@function.outer</code> |

## Resolved plugin inventory

Installed means a directory was present during this audit. It does not prove every external tool, language server or plugin action has been tested. Disabled plugin names are listed separately on the settings page.

| Plugin | Installed | Loaded in the audit after explicit picker/completion/refactor loads |
| --- | --- | --- |
| async.nvim | Yes | Yes |
| blink.cmp | Yes | Yes |
| clangd_extensions.nvim | Yes | Lazy / not yet |
| conform.nvim | Yes | Lazy / not yet |
| friendly-snippets | Yes | Yes |
| hardtime.nvim | Yes | Yes |
| harpoon | Yes | Lazy / not yet |
| lazy.nvim | Yes | Yes |
| lazydev.nvim | Yes | Lazy / not yet |
| LazyVim | Yes | Yes |
| lsp_signature.nvim | Yes | Lazy / not yet |
| lualine.nvim | Yes | Yes |
| LuaSnip | Yes | Lazy / not yet |
| mason-lspconfig.nvim | Yes | Lazy / not yet |
| mason-nvim-dap.nvim | Yes | Lazy / not yet |
| mason-tool-installer.nvim | Yes | Lazy / not yet |
| mason.nvim | Yes | Lazy / not yet |
| mini.ai | Yes | Yes |
| mini.diff | Yes | Yes |
| mini.icons | Yes | Lazy / not yet |
| mini.pairs | Yes | Yes |
| noice.nvim | Yes | Yes |
| nui.nvim | Yes | Yes |
| nvim-dap | Yes | Lazy / not yet |
| nvim-dap-python | Yes | Lazy / not yet |
| nvim-dap-ui | Yes | Lazy / not yet |
| nvim-dap-virtual-text | Yes | Lazy / not yet |
| nvim-lint | Yes | Lazy / not yet |
| nvim-lspconfig | Yes | Lazy / not yet |
| nvim-nio | Yes | Lazy / not yet |
| nvim-treesitter | Yes | Yes |
| nvim-treesitter-textobjects | Yes | Yes |
| nvim-ts-autotag | Yes | Lazy / not yet |
| plenary.nvim | Yes | Yes |
| refactoring.nvim | Yes | Yes |
| snacks.nvim | Yes | Yes |
| telescope-fzf-native.nvim | Yes | Yes |
| telescope.nvim | Yes | Yes |
| tokyonight.nvim | Yes | Yes |
| trouble.nvim | Yes | Yes |
| ts-comments.nvim | Yes | Yes |
| undotree | Yes | Lazy / not yet |
| venv-selector.nvim | Yes | Lazy / not yet |
| vim-dadbod | Yes | Lazy / not yet |
| vim-dadbod-completion | Yes | Lazy / not yet |
| vim-dadbod-ui | Yes | Lazy / not yet |
| which-key.nvim | Yes | Yes |

## Where to check later

Press **Space s k** for the current live key list. Use `:verbose nmap <leader>fr`, `:verbose imap <C-y>`, `:verbose xmap <leader>rs`, or `:verbose tmap <C-/>` for a particular mode. Open the relevant code file or plugin panel first when checking buffer-local keys. Consult `:help index` for unlisted built-in commands.
