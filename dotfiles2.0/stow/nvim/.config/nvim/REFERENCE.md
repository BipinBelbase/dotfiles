# My Neovim reference

Start here when you forget a shortcut. Your active Neovim is **LazyVim with personal overrides**, loaded through `~/.config/nvim` → `~/dotfiles/nvim`.

Reviewed against Neovim 0.12.5 and the locally installed LazyVim revision `99970099` on 2026-09-24. The older Neovim folders elsewhere in this repository are not this configuration.

## Find the right page

| Page | What you will find |
| --- | --- |
| [My custom shortcuts](docs/reference-custom.md) | Your changes first: save, clipboard, scrolling, Harpoon, completion, running, terminals and uppercase-D debugging |
| [Inherited shortcuts and plugin controls](docs/reference-defaults.md) | LazyVim defaults, ordinary Vim editing, file search, LSP, Git, refactoring, explorer, database and undo controls |
| [My settings and known surprises](docs/reference-settings.md) | Every active customization by config file, enabled/disabled features, conflicting bindings and limitations |
| [Complete mapping inventory](docs/reference-keymap-inventory.md) | Searchable snapshot of registered mappings, plugin declarations and language-dependent keys |
| [Python and C debugging walkthrough](docs/debugging.md) | Existing step-by-step debugging exercises |
| [All tools](../QUICK_REFERENCE.md) | Yabai, skhd, tmux and Neovim index |

## How to read the keys

- **Space** is your leader key. `Space f f` means press Space, release it, then type lowercase f twice.
- **Ctrl+k** means hold Ctrl and press k. **Cmd** is the macOS Command key; **Alt** is Option.
- Uppercase matters: `Space D b` requires **Shift+d**, then lowercase b. It is different from `Space d b`.
- **Normal**: press Escape before using the shortcut. **Insert**: typing text. **Visual**: text selected with `v`, `V` or Ctrl+v.
- A key inside an explorer, search popup or terminal can have a different meaning from the same key in a code buffer.
- **Built-in** means Neovim itself; **inherited** means LazyVim or an enabled plugin; **custom** means your own config changes it.

## The small daily set

| I want to… | Keys | Origin |
| --- | --- | --- |
| Find a project file | `Space f f` | Inherited; reliable alternative to Space Space |
| Search text across the project | `Space /` | Inherited |
| Browse folders | `Space e` | Custom Snacks Explorer |
| Find a file anywhere under home | `Space f F` | Custom |
| Save / name a new file | `Space f s` | Custom |
| Pin my current file | `Space h a` | Custom Harpoon |
| Jump to a pinned file | `Space 1` through `Space 5` | Custom Harpoon |
| See documentation / go to definition | `K` / `g d` | Inherited; needs an attached language server |
| Rename a code symbol | `Space c r` | Inherited; needs language-server support |
| Format | `Space c f` | Inherited |
| Accept a completion suggestion | `Ctrl+y` in Insert mode | Custom; select a suggestion first with Ctrl+n |
| Switch project session | `Ctrl+f` inside tmux | tmux normally intercepts it; Neovim also has a Normal-mode mapping |
| Search forgotten keybindings | `Space s k` | Inherited |

## A normal coding session

1. In tmux, press **Ctrl+f**, choose the project folder, then open Neovim there. The picker creates or reuses a named session; you do not have to type `cd` first. See the [tmux project workflow](../tmux/REFERENCE.md).
2. Use **Space f f** to open a file and **Space h a** to pin it. Use **Space 1–5** for files you revisit often.
3. Use **Space /** for project text, **gd** for a definition, and **Ctrl+o** to return.
4. Edit, use **Space c f** to format, then **Space f s** to save.
5. For a small supported file, **Space r r** saves and runs it. For an actual project, run its normal test/build command in a tmux pane or terminal.
6. Use **Space D b**, then **Space D c** when you need a breakpoint and debugger.

## Remember the three layers

| What you are controlling | Keys |
| --- | --- |
| macOS application windows | `Cmd+h/j/k/l` |
| tmux panes | `Ctrl+Space`, release, then lowercase `h/j/k/l` |
| Neovim splits | `Ctrl+w`, then `h/j/k/l` |
| Neovim files | `Space f f`, `Space ,`, or `Space 1–5` |

Your custom **Ctrl+k opens signature help**, so use **Ctrl+w k** to focus the upper Neovim split. macOS/skhd also captures **Cmd+f** for window zoom; use `/` or **Space /** to search in Neovim.

## When a shortcut seems different

Your replace, recent-file and disabled Space Space shortcuts stay consistent after Telescope loads. **Space r s** opens refactoring; **Space r l** is your live-server command. See [Known surprises](docs/reference-settings.md#known-surprises) for the decisions behind these mappings.

For current live help, press **Space s k** and search an action name, or **Space ?** for buffer mappings. To see who defined one particular shortcut, enter `:verbose nmap <leader>fr`. Use `:verbose imap <C-y>` for Insert mode, or `:verbose xmap <leader>rs` for Visual mode.

This reference documents config-defined mappings, relevant inherited mappings and common built-in editing keys. Plugin panels and language servers can add buffer-local keys when opened or attached; their local help and the live mapping search remain authoritative after updates.
