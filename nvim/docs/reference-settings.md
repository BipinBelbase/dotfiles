# My settings and known surprises

[Reference home](../REFERENCE.md) · [Custom keys](reference-custom.md) · [Inherited keys](reference-defaults.md)

This records the active configuration and explains what it changes. Values explicitly set in your files are distinguished from behavior that depends on loading a plugin, attaching a language server or entering a file type.

## Which files control what

| File | Purpose |
| --- | --- |
| [init.lua](../init.lua) | Loads your lazy.nvim setup |
| [lazy.lua](../lua/config/lazy.lua) | LazyVim imports, language extras, plugin loading and updates |
| [lazyvim.json](../lazyvim.json) | Additional enabled extras |
| [options.lua](../lua/config/options.lua) | Editing defaults and your Ctrl+a / Ctrl+y changes |
| [keymaps.lua](../lua/config/keymaps.lua) | Personal mappings, working-directory behavior, terminal and runner helpers |
| [autocmds.lua](../lua/config/autocmds.lua) | Custom number column on buffer/window entry |
| [editor.lua](../lua/plugins/editor.lua) | Harpoon, completion, parsers, database UI and UndoTree |
| [ui.lua](../lua/plugins/ui.lua) | Theme, statusline, dashboard, explorer, Telescope, Noice and Hardtime |
| [lsp_masons.lua](../lua/plugins/lsp_masons.lua) | Language tools, diagnostics, signatures and snippet loading |
| [debugging.lua](../lua/plugins/debugging.lua) | Moves debugger keys to uppercase Space D |
| [disable.lua](../lua/plugins/disable.lua) | Explicitly disabled plugins |
| [lazy-lock.json](../lazy-lock.json) | Recorded plugin revisions; documentation does not modify this file |

`~/.config/nvim` points to `~/dotfiles/nvim`. The files under `nvim2.0` and `dotfiles2.0` are separate copies, so editing them does not update this Neovim.

## Editor behavior

| Setting | Your value / effect |
| --- | --- |
| Leader / local leader | Space / backslash, inherited from LazyVim |
| Picker / completion | Telescope / Blink |
| Clipboard | Empty: ordinary y/d/p use Vim registers; explicit Space y and Space p p access macOS clipboard |
| Current directory | `autochdir = true`: follows the current file's directory |
| Indent | tabstop, softtabstop and shiftwidth 4; spaces instead of tabs; smart indent on |
| Wrapping | Off |
| Cursor margin | 8 lines above/below where possible |
| Mapping timeout | 100 ms for ambiguous key sequences; a very short pause allowance |
| Update time | 200 ms in inspected startup state, inherited |
| Swap / undo | Swap files off; persistent undo on |
| Cursor line | Off |
| Line numbers | Absolute current line and relative surrounding lines; custom shaded number column |
| Number / fold / sign columns | Number width 1, fold column 0, sign column always present |
| Color / opacity | True color; completion and floating-window blending 0 |
| Floating border | Rounded |
| Title | Filename, modified state and directory in the window title |
| Comment continuation | Removes `o` from formatoptions, so o/O do not automatically continue comments |
| Startup message | Removes `I` from shortmess, allowing the introductory message when otherwise applicable |

Filetype settings, EditorConfig, plugins and explicit runtime changes can override editor options. `:verbose set shiftwidth?` or `:verbose set autochdir?` shows the current value and its origin.

## Navigation, explorer and Harpoon

- Netrw is configured as a tree, with no banner, browsing in the current window and a nominal width of 60. Snacks is also configured to replace Netrw, so the custom Netrw helper does not guarantee a Netrw view.
- Snacks Explorer is configured with width 0.22, rounded borders and close-on-file-jump. The normal file search remains Telescope.
- Your home-directory Telescope finder includes hidden files, a preview and an 80%-width/height dropdown configuration.
- Harpoon uses branch harpoon2, a menu almost as wide as the editor, save-on-toggle, and a list key based on the working directory. Your config supplies `sync_on_toggle = false`; the installed plugin's documented setting is `sync_on_ui_close`, so do not treat the former spelling as a verified control.

## Completion, snippets and signatures

- Blink uses LSP, paths, snippets and buffer words, with LazyDev for Lua. The explicit key preset is `none`; only your Ctrl+n/p/y/e choices are supplied for Insert completion.
- No automatic suggestion preselection or insertion; no completion ghost text; completion documentation does not open automatically. Menu/documentation/signature borders are rounded and opaque.
- The merged configuration still has a separate Blink command-line preset and command-line ghost text. Insert-mode choices do not describe every command-line behavior.
- LuaSnip is declared, with friendly snippets limited to Python, JavaScript, TypeScript and C when loaded. The inspected Blink configuration still selects its built-in `default` snippet preset; merely declaring LuaSnip does not prove Blink uses it.
- lsp_signature loads on LspAttach. Its popup has at most 3 lines of height and 40 columns, up to 3 documentation lines, no inline hint, a 200-ms timer, configured auto-close value 3 and close timeout 3000 ms. Ctrl+n selects another signature, overlapping completion navigation.
- Noice's separate signature integration is disabled. Normal Ctrl+k is your lsp_signature toggle; inherited gK is another route to LSP signature help.

## Languages, formatting and debugging

Extras imported in lazy.lua: ESLint, Prettier, TypeScript, JSON and Rust. Extras in lazyvim.json: DAP core, Harpoon2, mini.diff, refactoring, Snacks Explorer, clangd and Python.

| Feature | Current configuration |
| --- | --- |
| Python | Pyright and Ruff; VenvSelect; debugpy-backed DAP |
| C/C++ | clangd with background index, clang-tidy, include insertion and placeholders; CodeLLDB debugging |
| TypeScript/JavaScript | vtsls from the language extra; ESLint integration; TypeScript-specific code actions |
| Old tsserver settings | Present in your file, but merged tsserver is disabled; these custom inlay settings do not configure vtsls |
| JSON | jsonls formatting and validation; SchemaStore plugin disabled |
| Lua | lua_ls and LazyDev; StyLua formatting |
| Rust | Rust extra imported, but rustaceanvim disabled and merged rust_analyzer disabled; a cargo runner alone is not Rust LSP support |
| Inlay hints | Globally disabled initially, toggle via Space u h |
| Code lenses | Automatic code-lens behavior disabled in merged LSP opts; actions require server support |
| Formatting | Conform/LazyVim formatting; Prettier explicitly requires a project config |
| DAP UI | Opens on debugger initialization and closes on terminate/exit; virtual-text plugin enabled |

Your Mason installer requests Prettier, Pyright, Ruff, ESLint, lua_ls, StyLua, debugpy and codelldb. It is configured to install on startup when the installer plugin loads, without automatic tool updates. A requested tool is not proof it is installed, attached or using your project's environment. Check `:Mason`, `:checkhealth vim.lsp` and `:ConformInfo` when necessary.

Your explicit Treesitter parser list contains Bash, HTML, CSS, JavaScript, TypeScript, TSX, JSON, Lua, Markdown and inline Markdown, Python, query, regex, Vim, YAML, Java, C and C++. Language extras can extend this list. Treesitter provides syntax structure, not a language server or compiler.

## Diagnostics

You configure quiet diagnostics: inline virtual text off, LSP underlining off, no updates while inserting, sorted severity and custom error/warning/info icons. Separately, lazy.lua requests error-only signs and floating diagnostics.

These settings come from two places. The isolated startup snapshot showed underlining still on and severity sorting off before nvim-lspconfig loaded; the merged LSP options set underlining off and severity sorting on. Do not describe the startup snapshot as the final state in every code buffer. Open a code file and inspect `:lua print(vim.inspect(vim.diagnostic.config()))` if needed.

The custom Space j/k mappings themselves do **not** filter to errors. Space cb is a popup, not a whole-file list. Use the dedicated error motions and diagnostic lists in the inherited reference.

## Appearance and feedback

- Transparent TokyoNight theme, sidebars and theme floating backgrounds; menu blend values remain zero.
- Lualine has a global transparent statusline. It displays mode, branch, file path, macro recording, diff, diagnostics, location and progress. Its top line only lists loaded buffers that are current or modified; it is not a list of every open buffer. Bufferline is disabled.
- Your autocmd rewrites the number column on BufEnter/WinEnter. The current and nearest three relative numbers use progressively dimmer colors; farther numbers use the darkest shade, with a vertical separator.
- Which-key is enabled with a compact rounded popup. Its bottom help, echoed key text and mapping icons are hidden, with tightly constrained dimensions. Space ? and Space sk remain useful explicit discovery tools.
- Noice places command input at the bottom, disables LSP progress and its scrolling option, uses bordered docs and sends long messages to a split. “No information available” and some “written” messages are filtered out. The 5000-ms notify setting and duplicate long-message option are configuration entries, not extra keybindings.
- The Snacks dashboard has your welcome header, keys and startup sections. A custom floating-layout table and button options are supplied; layout rendering was not visually verified during this documentation audit.
- Trouble has `focus = true`, so it takes focus. The comment claiming this prevents focus is backwards.
- Hardtime starts eagerly with default options. It discourages repeated h/j/k/l-style movement, blocks arrow keys in ordinary buffers, and defaults to disabling the mouse. `:Hardtime toggle`, `:Hardtime enable`, `:Hardtime disable`, and `:Hardtime report` control it. Popup/filetype exceptions and load order can affect its behavior.

## Database settings

Dadbod UI loads through DBUI commands, enables Nerd Font icons and declares Dadbod plus SQL completion dependencies. Your spec also contains `auto_execute`, `border` and `save_location` in an opts table. The Vimscript plugin documents global `g:db_ui_*` options; do not assume those arbitrary Lua opts implement automatic execution or saving. Consult `:help vim-dadbod-ui` and the active plugin configuration before relying on them.

## Disabled and inactive features

Explicitly disabled: Catppuccin, Dressing, crates.nvim, rustaceanvim, grug-far, todo-comments, persistence, SchemaStore, Neo-tree, Flash and Bufferline. mini.diff also disables Gitsigns. Thus generic LazyVim instructions for Flash jumps, persistence sessions, todo lists, Gitsigns staging or grug-far replacement do not match this setup.

Commented examples are inactive: CursorHold diagnostic popup, colorcolumn 79, alternative quickfix/location shortcuts, the simple old save mapping, vim-be-good, Gruvbox, Fidget, alternative dashboard/statusline designs and extra Mason tools. They are source notes, not available shortcuts.

## Known surprises

The original mappings competed for these keys. Their current behavior is now settled:

| Mapping | After personal keymaps load | After the relevant plugin loads | Reliable approach today |
| --- | --- | --- | --- |
| Space f r | Find and replace word under cursor | Same mapping retained | Use Space f R for recent files |
| Space f R | Recent files | Same mapping retained | Your recent-files picker |
| Space Space | No-op | Same no-op retained | Use Space f f for project files |
| Space r s | Refactoring selector | Same refactoring action | Live-server command is Space r l |

Other details that can explain surprising behavior:

- **Harpoon list changes between folders:** autochdir and directory-keyed lists interact. Confirm with `:pwd`; no stable project-root key was added.
- **Signature toggle errors before an LSP attaches:** lsp_signature is configured for LspAttach. Normal Ctrl+k may not have usable signature context yet.
- **Slow leader sequences fail:** timeoutlen is 100 ms and several short keys are prefixes of longer keys. Which-key delays and plugin mappings also influence the experience.
- **Space d waits:** inherited Space dpp/dph/dps profiler bindings share your black-hole-delete prefix. Debugger remapping to uppercase D does not remove these profiler bindings.
- **Runner q fails:** the runner's mapping calls a local close function by a global name. Exit terminal mode and use :close. The separately implemented Space tt close callback is valid.
- **Runner paths / environments:** shell commands interpolate filenames, Java assumes a simple class layout, Make assumes a filename-derived target, and Docker derives a tag from an absolute stem. These helpers are not verified project build systems. Closing/recreating the terminal can also affect a running job.
- **live-server message is optimistic:** its helper does not verify successful creation of the fixed-name tmux session. A duplicate name or missing executable can fail while the message still prints success.
- **Ctrl+f belongs to the first layer that receives it:** tmux binds it without a prefix; when Neovim receives it, only Normal mode runs your picker. Outside tmux that custom mapping only displays a message.
- **Space fc/fF vs cwd:** project-root search and current-directory search differ, especially with autochdir on. Space fF is specifically your home finder.

Other existing limitations are documented here; the shortcut overlaps above have been resolved.

## Updates and evidence

lazy.nvim disables periodic update checks and change notifications; plugin defaults are lazy-loaded and use `version = false`, while lazy-lock.json records revisions. Neovim does not support simply re-sourcing the whole lazy setup; restart Neovim after configuration changes. Built-in runtime plugins gzip, tarPlugin, tohtml, tutor and zipPlugin are disabled in lazy.nvim's runtime-path settings; Netrw is not disabled there.

The audit used local installed source and isolated headless mapping snapshots: after VeryLazy, then after explicitly loading Telescope, refactoring and Blink and waiting for lazy.nvim's scheduled load event. The intended keys were verified in both stages. Missing-plugin installation, periodic checks and the tool installer's automatic run were suppressed in that temporary audit process. It did not exercise GUI rendering, debugger breakpoints, database queries, project runners or every language server. See the [mapping inventory](reference-keymap-inventory.md) for the snapshot scope and language-dependent declarations.

After plugin updates, use Space sk and :verbose map to resolve differences. This reference is a dated record of your configuration, not a promise that upstream defaults never change.
