# My custom Neovim shortcuts

[Reference home](../REFERENCE.md) · [Inherited shortcuts](reference-defaults.md) · [Settings](reference-settings.md)

Start in Normal mode unless a row says otherwise. Space is the leader. Case matters.

## Files and projects

| Keys | What your mapping does | How it differs |
| --- | --- | --- |
| `Space f s` | Save; ask for a filename if the buffer is unnamed. Normal and Visual modes. | Your save helper |
| `Cmd+s` | Save in Normal mode if Ghostty sends that key to Neovim | Terminal-dependent convenience; Space f s is more portable |
| `Space e` | Open Snacks Explorer | Your direct explorer callback |
| `Space p v` | Toggle the Netrw explorer using Explore / buffer close | Snacks also replaces Netrw, so this can be intercepted |
| `Space f F` | Telescope file search under your home folder, with hidden files and preview | Overrides LazyVim's current-directory file search |
| `Space f r` | Find and replace the word under the cursor throughout the file | Reapplied after Telescope loads |
| `Space f R` | Open recent files | Reapplied after Telescope loads |
| `Ctrl+f` | Open a tmux window running your project sessionizer; otherwise print “Not in a tmux session” | Normal mode only; replaces forward page scrolling there |
| `Space f x` | Make the current file executable | Runs chmod on the file; current mapping does not quote the filename |
| `Ctrl+q` | Close the current Neovim window with ordinary unsaved-change protection | Can be intercepted by terminal flow control |

`Space Space` stays disabled even after Telescope loads. Use **Space f f** to find project files.

## Your clipboard and editing changes

Your normal Vim clipboard is separate from the macOS clipboard (`clipboard` is empty).

| Keys | Mode | Action |
| --- | --- | --- |
| `Space y` + motion | Normal | Copy the motion to the macOS clipboard; e.g. `Space y i w` copies the word |
| `Space y` | Visual | Copy the selection to the macOS clipboard |
| `Space Y` | Normal | Copy the whole line to the macOS clipboard; this non-remapped mapping invokes built-in Y |
| `Space p p` | Normal / Visual | Paste from the macOS clipboard |
| `Space p n` | Visual | Replace selection with the ordinary Vim paste register without storing deleted text |
| `Space d` + motion | Normal | Delete without changing your yank register; e.g. `Space d i w` |
| `Space d` | Visual | Delete selection without replacing copied text |
| `Ctrl+a` | Normal / Insert | Select the entire file; leaves Insert mode if necessary |
| `Ctrl+y` | Normal | Redo; different from its Insert-mode completion meaning |
| `J` | Normal | Join the next line while keeping the cursor position |
| `J` / `K` | Visual | Move selected lines down / up and reindent them |
| `Q` | Normal | Disabled |
| `Space p` | Normal | No standalone action; prefix for paste and explorer commands |

## Scrolling and search

| Keys | Mode | Action |
| --- | --- | --- |
| `Enter` | Normal / Visual | Half-page down, then center the cursor |
| `Backspace` | Normal | Half-page up, then center the cursor |
| `Backspace` | Visual | Move the selection cursor up **16 lines**; not half a page |
| `Ctrl+d` / `Ctrl+u` | Normal | Half-page down / up and center |
| `n` / `N` | Normal | Next / previous result relative to the search direction, center it and open folds |

Your n/N mappings use ordinary Vim search direction. A search started with `?` therefore reverses the direction compared with `/`.

## Harpoon: your five working files

| Keys | Action |
| --- | --- |
| `Space h a` | Add the current file |
| `Space h h` | Open the Harpoon list |
| `Space 1`, `Space 2`, `Space 3`, `Space 4`, `Space 5` | Jump to that list entry |

`Space H` is disabled by your Harpoon spec. The menu is nearly the editor width and saves on toggle. Lists are keyed by the current working directory. Because `autochdir` is enabled, opening a file in another folder can switch the Harpoon list too.

## Completion and function help

These completion keys apply while typing with Blink's menu active.

| Keys | Action |
| --- | --- |
| `Ctrl+n` | Select the next suggestion |
| `Ctrl+p` | Select the previous suggestion; fall back if the menu cannot handle it |
| `Ctrl+y` | Accept the selected suggestion; fall back if there is none |
| `Ctrl+e` | Cancel completion; fall back when appropriate |
| `Ctrl+Space` | No Blink action in your custom Insert-mode map; tmux uses it as prefix |
| `Ctrl+k` in Normal mode | Toggle the lsp_signature floating help window |
| `Ctrl+n` while signature help handles input | Cycle available function signatures; this overlaps completion's next-item key |

You use Blink's `none` key preset: do not assume generic Tab/Enter-to-accept instructions apply. Suggestions are not preselected or inserted automatically. Inline ghost text and automatic completion documentation are off. Signature help has a rounded, compact popup and requires an attached server.

## Diagnostics and splits

| Keys | Action |
| --- | --- |
| `Space c b` | Diagnostic popup at the cursor/line; despite its description, not a whole-file error list |
| `Space j` / `Space k` | Next / previous diagnostic; not restricted to errors by the mapping |
| `Ctrl+Up` / `Ctrl+Down` | Increase / decrease split height by 2 |
| `Ctrl+Left` / `Ctrl+Right` | Decrease / increase split width by 2 |
| `Space c u` | Toggle UndoTree |

For errors only, use the inherited **]e / [e**. For a whole-file list use **Space x X** or **Space s D**.

## Run, terminal and web preview

| Keys | Action |
| --- | --- |
| `Space r r` | Save the file and run its configured command in an 80%-wide, half-height floating terminal |
| `Space t t` | Open a fresh shell in a 70%-wide, 60%-height floating terminal |
| `Space r l` | Request a detached tmux session named live-server |
| `Space r s` | Select a refactoring action after the refactoring plugin loads |

In the shell opened by Space t t, **Ctrl+backslash, then Ctrl+n** leaves terminal-input mode; then **q** closes that float. Reopening Space t t creates a new shell; it is not a persistent terminal toggle.

The run-output float's q callback currently references a local function as though it were global. Use **Ctrl+backslash, Ctrl+n**, then **:close** to close that output window instead. See the settings page for runner limitations.

| File type | Configured runner |
| --- | --- |
| C / C++ | gcc / g++, executable beside the source, then run |
| Python | python3 on the current file |
| Java | javac, then java using the source basename |
| Rust | cargo run from the current directory |
| JavaScript / TypeScript | node / npx ts-node |
| HTML | Open the file in the default application |
| Go / Lua | go run / lua |
| Shell / Zsh | bash / zsh |
| PHP / Ruby / Perl | php / ruby / perl |
| Make | make in the file directory with the filename stem as target |
| Dockerfile | docker build using the source stem as image tag |

These are simple file commands. They do not select every project's environment, test suite, compiler flags or dependency setup. Dockerfile's path-derived tag and Java/Make assumptions may not fit your project.

## Debugging: uppercase D

Your override moves LazyVim debugger mappings from **Space d** to **Space D**, preserving your black-hole delete command. Debugger availability still depends on the language adapter and project setup.

| Keys after Space | Action |
| --- | --- |
| `D b` / `D B` | Toggle breakpoint / set conditional breakpoint |
| `D c` / `D a` | Start or continue / run with arguments |
| `D C` | Run to cursor |
| `D i` / `D O` / `D o` | Step into / over / out |
| `D j` / `D k` | Move down / up the call stack |
| `D g` | Go to line without executing intermediate code |
| `D l` | Run the last debug configuration |
| `D P` | Pause |
| `D r` | Toggle debugger REPL |
| `D s` | Request current session; not a session-picker UI |
| `D t` | Terminate |
| `D w` | Hover debugger widgets |
| `D u` | Toggle debugger panels |
| `D e` | Evaluate expression or Visual selection |
| `D P t` / `D P c` | Python: debug test method / test class |

Follow the existing [Python/C walkthrough](debugging.md) for the actual launch process. Do not confuse ordinary **Space r r** execution with debugging.

## Your overrides compared with upstream

| Key or behavior | Original convention | Your configuration |
| --- | --- | --- |
| Ctrl+a | Vim increment number | Select all |
| Ctrl+y in Normal | Vim scroll screen upward | Redo |
| Ctrl+f in Normal | Vim forward page / Noice scroll | tmux project picker |
| Ctrl+k in Normal | LazyVim upper split | Signature help |
| Enter in Normal | Vim move to next line | Centered half-page down |
| Space f F | LazyVim current-directory search | Home-directory search |
| Space f r | LazyVim recent files | Your find-and-replace helper, retained after Telescope loads |
| Space f R | LazyVim recent files in current directory | Your recent-files picker |
| Space Space | LazyVim file finder | Disabled consistently, including after Telescope loads |
| Space r s | Refactoring menu | Refactoring menu; live-server moved to Space r l |
| Space d… debugger | LazyVim debugger prefix | Uppercase Space D… |
| Space H | LazyVim Harpoon shortcut | Disabled; use Space h a / h h |
| Clipboard | LazyVim system integration | Separate Vim clipboard with explicit Space y / p p |

Sources: [keymaps.lua](../lua/config/keymaps.lua), [options.lua](../lua/config/options.lua), [editor.lua](../lua/plugins/editor.lua), [debugging.lua](../lua/plugins/debugging.lua), [ui.lua](../lua/plugins/ui.lua), [lsp_masons.lua](../lua/plugins/lsp_masons.lua).
