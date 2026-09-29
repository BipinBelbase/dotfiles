# Inherited shortcuts and plugin controls

[Reference home](../REFERENCE.md) · [My custom shortcuts](reference-custom.md) · [Full inventory](reference-keymap-inventory.md)

These come from your installed LazyVim, enabled plugins or Neovim itself. They are separate from your personal overrides. Unless marked otherwise, use Normal mode. Uppercase letters require Shift.

## Files, search and buffers

| Keys | Action |
| --- | --- |
| `Space f f` | Find files in the detected project root |
| `Space f g` | Find Git-tracked files |
| `Space f c` | Find Neovim configuration files |
| `Space f n` | Create an empty buffer |
| `Space f R` | Recent files in current directory |
| `Space ,` / `Space f b` | Switch buffers, ordered by recent use |
| `Space f B` | All buffers |
| `Space /` / `Space s g` | Search project text |
| `Space s G` | Search text from current working directory |
| `Space s w` / `Space s W` | Search cursor word or Visual selection in project / current directory |
| `Space s b` | Search lines in this buffer |
| `Space s s` / `Space s S` | Document / workspace symbols; needs LSP |
| `Space s R` | Resume the last Telescope picker |
| `H` / `L`, `[b` / `]b` | Previous / next buffer |
| `Space b b` / Space + backtick | Alternate buffer |
| `Space b d` | Close buffer while preserving the window layout |
| `Space b D` | Close buffer and its window |
| `Space b o` / `Space b i` | Close other / invisible buffers |

**Exceptions:** Space f F searches home; Space f r is your replacement helper; Space f R opens recent files; Space Space stays disabled. Use Space f f for project files.

## Inside Telescope

| Keys | Action |
| --- | --- |
| Type text | Filter candidates |
| `Ctrl+n` / `Ctrl+p`, arrows | Next / previous result |
| `Enter` | Open selection |
| `Ctrl+x` / `Ctrl+v` | Open in horizontal / vertical split |
| `Ctrl+c` | Close immediately |
| `Escape`, then `q` | Switch to Normal mode, then close |
| `Tab` / `Shift+Tab` | Toggle item selection and advance / go back |
| `Ctrl+q` / `Alt+q` | Put all / selected results in quickfix |
| `Ctrl+u` / `Ctrl+d` | Scroll preview up / down |
| `Ctrl+b` / `Ctrl+f` in picker Insert mode | LazyVim preview scroll up / down; Ctrl+f is not the project picker here if Neovim receives it |
| `Ctrl+Up` / `Ctrl+Down` in picker Insert mode | Previous / next search history |
| `Alt+h` / `Alt+i` in picker Insert mode | Reopen file search requesting hidden / ignored files; not an on/off toggle |
| `Alt+c` when offered | Repeat a project-root picker from current directory |
| `Ctrl+t` / `Alt+t` in picker Insert mode | Open results in Trouble; overrides Telescope's usual Ctrl+t tab action |
| `j/k`, `gg/G`, `H/M/L` in picker Normal mode | Result navigation |
| `Ctrl+/` in Insert, `?` in Normal | Show picker key help |

tmux's global Ctrl+f binding can capture that key before Telescope sees it. Ctrl+d/u remain useful preview controls.

## Inside Snacks Explorer

Open with **Space e**; **Space f e** uses the project root, and **Space E / Space f E** use the current directory. These are different from Telescope file search.

| Keys in explorer list | Action |
| --- | --- |
| `j/k`, `Enter` or `l` | Navigate and open item |
| `h` / `Backspace` | Close directory / go to parent |
| `a` / `r` | Add / rename file or directory |
| `c` / `m` | Copy / move item |
| `d` | Delete item; review the prompt |
| `y` / `p` | Copy path / paste copied items |
| `o` | Open with the system application |
| `P` | Toggle preview |
| `H` / `I` | Toggle hidden / ignored files |
| `Z` | Close all directory nodes |
| `.` / `u` | Focus current file / update explorer |
| `Ctrl+c` | Set tab working directory to selection |
| `Ctrl+t` | Open terminal |
| `Space /` | Search with a grep picker |
| `[g` / `]g` | Previous / next Git change |
| `[d` / `]d`, `[w` / `]w`, `[e` / `]e` | Previous / next diagnostic, warning or error |

Your explorer is narrow (configured width 0.22), has rounded borders, follows files, and closes when jumping to a file. Its buffer-local Backspace takes precedence over your code-buffer scrolling shortcut.

## Language intelligence and diagnostics

LSP means a language server attached to the current code buffer. Keys may appear only after attachment and when the server supports the action.

| Keys | Action |
| --- | --- |
| `g d` / `g D` | Definition / declaration |
| `g r` / `g I` / `g y` | References / implementation / type definition |
| `K` | Hover documentation |
| `g K` or `Ctrl+k` in Insert | Signature help |
| `Space c r` | Rename symbol across its references |
| `Space c R` | Rename file with language-server support |
| `Space c a` / `Space c A` | Code action / source action |
| `Space c o` | Organize imports where supported |
| `Space c c` / `Space c C` | Run / refresh code lenses where supported |
| `Space c l` | LSP information |
| `[[` / `]]`, `Alt+p` / `Alt+n` | Previous / next highlighted reference where supported |
| `Space c f` | Format file or selection |
| `Space c F` | Format injected language, where supported |
| `Space c d` | Diagnostic popup |
| `[d` / `]d` | Previous / next diagnostic |
| `[e` / `]e` | Previous / next error |
| `[w` / `]w` | Previous / next warning |
| `Space s d` / `Space s D` | Telescope diagnostics: workspace / current buffer |
| `Space x x` / `Space x X` | Trouble diagnostics: workspace / current buffer |
| `Space c s` / `Space c S` | Trouble symbols / LSP references and definitions |
| `Space x q` / `Space x l` | Built-in quickfix / location list |
| `Space x Q` / `Space x L` | Trouble quickfix / location list |
| `[q` / `]q` | Previous / next Trouble or quickfix result |

Language-specific: **Space c v** selects a Python environment. **Space c h** switches C/C++ source/header. TypeScript's vtsls uses **gD** for source definition, **gR** for file references, **Space c M** to add missing imports, **Space c D** to fix diagnostics, and **Space c V** to choose a workspace TypeScript version. The local-leader **backslash, then r** runs Lua through Snacks in its applicable context; this is distinct from your Space r r file runner.

## Git changes

Your enabled backend is **mini.diff**. Gitsigns is disabled by the mini.diff extra, even though your UI file contains Gitsigns appearance settings.

| Keys | Action |
| --- | --- |
| `[h` / `]h`, `[H` / `]H` | Previous / next, first / last changed hunk |
| `Space g o` | Toggle the inline diff overlay |
| `Space u G` | Toggle mini.diff signs |
| `g h` + motion, or Visual `g h` | Apply selected hunks to the reference; with the Git source, stage them |
| `g H` + motion, or Visual `g H` | Reset selected hunks to the reference; discards those working edits |
| `g h g h` | Apply/stage the current hunk using the hunk text object |
| `Space g g` / `Space g G` | Lazygit at project root / current directory, when executable is installed |
| `Space g c` / `Space g l` | Telescope commit history |
| `Space g s` / `Space g S` | Telescope Git status / stash list |
| `Space g L` | Snacks Git log in current directory |
| `Space g b` / `Space g f` | Line history / current file history |
| `Space g B` / `Space g Y` | Open repository URL / copy repository URL; also works on Visual selection |

## Refactoring

These come from the enabled refactoring extra, not your file runner. Many need a syntax parser and a suitable expression or selection.

| Keys | Action |
| --- | --- |
| `Space r s` | Select refactoring |
| `Space r i` | Inline variable |
| `Space r f` / `Space r F` | Extract function / extract function to file |
| `Space r x` | Extract variable |
| `Space r p` | Insert debug print for variable |
| `Space r P` | Insert debug print for location |
| `Space r c` | Clean debug prints |

Selection/refactoring actions are mapped in Normal and Visual modes; location-print and cleanup keys are Normal-only.

## Splits, tabs and terminals

| Keys | Action |
| --- | --- |
| `Space -` / Space + vertical bar | Split below / right |
| `Ctrl+w`, then `h/j/k/l` | Focus left / down / up / right split |
| `Ctrl+h/j/l` | Direct left / down / right focus; your Ctrl+k is signature help |
| `Space w d` | Close split |
| `Space w m` / `Space u Z` | Toggle split zoom |
| `Space u z` | Toggle Zen mode |
| `Ctrl+w`, then `Space` | Window-key help mode |
| `Space Tab Tab` | New Neovim tab page |
| `Space Tab [` / `Space Tab ]` | Previous / next tab page |
| `Space Tab f` / `Space Tab l` | First / last tab page |
| `Space Tab d` / `Space Tab o` | Close current / other tab pages |
| `Space f t` / `Space f T` | Snacks terminal at project root / current directory |
| `Ctrl+/` (also Ctrl+underscore) | Focus Snacks project terminal; available in Normal and Terminal modes |
| `Space q q` | Quit all editor windows, respecting unsaved changes |

Buffer = file, split = view into a buffer, tab page = arrangement of splits. A Neovim tab is separate from a tmux window or macOS Space.

## Built-in editing worth remembering

| Keys | Action |
| --- | --- |
| `i`, `a`, `I`, `A` | Insert before/after cursor, start/end of line |
| `o` / `O` | New line below / above |
| `Escape` | Return to Normal mode; LazyVim also clears search highlights and stops snippets |
| `v`, `V`, `Ctrl+v` | Character / line / block selection |
| `w`, `b`, `e`, `0`, `^`, `$`, `gg`, `G` | Word, line and file motions |
| Count + motion, e.g. `5j`, `3w` | Move a specific distance; useful with Hardtime |
| `f`/`t` + character, `;` / `,` | Find/till character; repeat forward/backward |
| `%` | Matching bracket or syntax pair |
| `d`, `c`, `y` + motion | Delete, change or copy |
| `d d`, `c c`, `y y` | Delete, change or copy whole line |
| `p` / `P` | Paste after / before from Vim's register |
| `u` / `Ctrl+r` | Undo / redo; your Ctrl+y also redoes in Normal mode |
| `.` | Repeat last change |
| `/text`, `?text` | Search forward / backward |
| `*` / `#` | Search cursor word forward / backward |
| `Ctrl+o` / `Ctrl+i` | Older / newer jump-list location |
| `m a`, `'a`, backtick + `a` | Set mark a; jump to marked line / exact position |
| `q a`, then edits, then `q`; `@a`, `@@` | Record and replay a macro |
| `g c c` / Visual `g c` | Comment current line / selection |
| `g c o` / `g c O` | Add commented line below / above |
| Visual `<` / `>` | Indent and keep selection |
| `Alt+j` / `Alt+k` | Move lines down/up in Normal, Insert or Visual mode |

Your **Normal J**, **Visual J/K**, **Enter**, **Backspace**, **Ctrl+a**, **Ctrl+f**, **Ctrl+y** and **Q** are changed; see the custom page. Hardtime can block repeated direction keys and arrows in ordinary editing buffers.

## Text objects and syntax movement

Use an operator plus inside/around: **ciw** changes inside a word, **di"** deletes inside quotes, **va(** selects around parentheses. mini.ai adds **if/af** for a function, **ic/ac** for a class, **io/ao** for a block/conditional/loop, **ia/aa** for an argument, **it/at** for a tag, **id/ad** for digits, **ie/ae** for word parts, **ig/ag** for the whole buffer, and **iu/au / iU/aU** for function calls. Parsing-dependent objects require a parser for the file type. It searches up to 500 surrounding lines.

mini.ai also supplies next/last variants (**in/an**, **il/al** followed by the object), and **g[ / g]** to an object's surrounding edges. Snacks adds **ii/ai** for indent scope and **[i / ]i** for scope edges. Treesitter textobject motions, when attached, are **[f / ]f** function starts, **[F / ]F** ends; **[c / ]c**, **[C / ]C** class starts/ends; **[a / ]a**, **[A / ]A** parameter starts/ends.

## Settings toggles and help

| Keys after Space | Action |
| --- | --- |
| `u f` / `u F` | Autoformat globally / for this buffer |
| `u s`, `u w` | Spelling / line wrap |
| `u l`, `u L` | Line numbers / relative numbers |
| `u d`, `u h` | Diagnostics / inlay hints |
| `u c`, `u A` | Conceal / tabline |
| `u T`, `u b` | Treesitter highlights / dark background |
| `u D`, `u a`, `u g`, `u S` | Dimming / animation / indent guides / smooth scroll |
| `u p` | Automatic bracket pairs |
| `u C` | Preview colorschemes |
| `u r` | Clear highlights, refresh diffs and redraw |
| `u i` / `u I` | Inspect highlight / syntax tree |
| `n` / `u n` | Notification history / dismiss notifications |
| `s n l`, `s n h`, `s n a`, `s n d`, `s n t` | Noice last message / history / all / dismiss / picker |
| `l`, `L`, `c m` | Lazy plugin manager / LazyVim changelog / Mason tool manager |
| `?`, `s k`, `s h` | Buffer key help / search mappings / search help pages |
| `s "`, `s /`, `s j`, `s m` | Registers / search history / jump list / marks |
| `:`, `s c`, `s C`, `s a` | Command history / command history / commands / autocommands |
| `s H`, `s M`, `s o`, `s l`, `s q` | Highlights / man pages / options / location list / quickfix |
| `.`, `S` | Toggle / select a scratch buffer |

**Shift+Enter** redirects a command-line result through Noice. **Ctrl+b/f** scroll Noice documentation where active; Normal Ctrl+f is your override. Profiling shortcuts **Space d p p / d p h / d p s** remain inherited and share the prefix of your delete operator; avoid assuming they belong to the uppercase-D debugger group.

## Database, UndoTree and Harpoon panels

**Database:** `:DBUI` / `:DBUIToggle` open the panel; `:DBUIAddConnection` and `:DBUIFindBuffer` manage connections/current query. In the drawer: **Enter/o** open, **S** open vertically, **R** redraw, **d** delete item, **A** add connection, **H** details, **r** rename, **q** close, **?** help. **J/K** next/previous sibling, **Ctrl+j/k** last/first sibling, **Ctrl+p/n** parent/child. SQL buffers: **Space S** executes query or selection, **Space W** saves query, **Space E** edits bind parameters. Results: **Space R** toggles supported expanded layouts. These are buffer-local and can replace global keys while that panel is focused. Running SQL executes it against your selected database.

**UndoTree:** **Space c u** opens history. Inside the panel: **?** help, **q** close, **Tab** return to editor, **Enter** or double-click select state, **J/K** previous/next undo state, **</>** previous/next saved state, **u / Ctrl+r** undo/redo, **D** toggle diff panel, **=** set diff marker, **M** clear marker, **T** toggle relative timestamps, **C** clear history with confirmation. Selecting a past change changes the file buffer's contents; ordinary save is still separate. Persistent undo is enabled.

**Harpoon:** **Space h h** opens the list; edit its lines to organize entries and choose a file with Enter. **q / Escape** close the list, and **:w** saves it and closes. Use **Space 1–5** outside the list for direct jumps.

## Live help is your fallback

Use **Space s k**, `:map`, `:imap`, and `:verbose nmap <key>` to inspect current mappings. Built-in commands are documented in `:help index`; panel-specific documentation is available with `:help telescope`, `:help mini.ai`, `:help mini.diff`, `:help undotree`, and `:help vim-dadbod-ui`. The [full inventory](reference-keymap-inventory.md) preserves the reviewed global and declared plugin mappings without requiring you to memorize them.
