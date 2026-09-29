# Python and C debugging

This configuration enables LazyVim's DAP core plus the existing Python and
clangd extras. Mason already lists `debugpy` and `codelldb`; installing an adapter
alone does not connect it to Neovim. DAP core supplies that client connection.

## Install only the missing pieces

Use the `nvim/` config linked by `install_mac.sh`, not the older copies under
`nvim2.0/` or `dotfiles2.0/`. Inside Neovim, check:

```vim
:lua print(vim.fn.stdpath("config"))
:Lazy install
:MasonInstall debugpy codelldb
```

Wait for installation to finish, restart Neovim, and open a Python or C file.
`:Lazy install` installs missing plugins without requesting a general plugin
update. New plugins will be recorded in your local `lazy-lock.json`; review those
new entries rather than replacing the existing lockfile wholesale.

Then inspect the configured adapters:

```vim
:lua print(vim.inspect(require("dap").adapters))
:lua print(vim.inspect(require("dap").configurations[vim.bo.filetype]))
```

Expect Python launch configurations in a Python buffer, and `codelldb` launch
and attach configurations in a C buffer. `:checkhealth dap` and `:DapShowLog`
help investigate adapter startup errors. Check installation failures in Mason
before modifying permissions or changing interpreter paths.

## Keys: Space, then uppercase D

Your existing `Space d` black-hole delete mapping is preserved. Debugger mappings
use uppercase `D` (Shift+d), so they do not share that prefix.

| Keys | Action |
| --- | --- |
| `Space D b` | Toggle breakpoint |
| `Space D c` | Start / continue |
| `Space D O` | Step over (uppercase O) |
| `Space D i` | Step into |
| `Space D o` | Step out |
| `Space D u` | Toggle debugger UI |
| `Space D e` | Evaluate expression / selection |
| `Space D t` | Terminate session |

Use `:verbose nmap <leader>Db` to see the active mapping. Normal `Space d`
and visual-mode `Space d` still delete into the black-hole register.
The Python method/class test mappings also move to uppercase D.

## Python: stop, inspect, step

Create `debug_demo.py` in a small test project:

```python
left = 6
right = 4
total = left + right
print(total)
```

1. Start Neovim from the project directory. For a project with dependencies,
   activate its environment first (`source .venv/bin/activate`) or use
   `:VenvSelect`. The debug adapter's Python and your program's Python have
   different jobs; the program must use the environment containing its imports.
2. Put a breakpoint on `print(total)` with `Space D b`.
3. Press `Space D c`; select the Python launch-file configuration when prompted.
4. When execution stops, inspect `total` in the Scopes panel: it must be **10**.
5. Press `Space D O`, then continue to completion. Output must be **10**.

A breakpoint stops before that line executes. Setting it on the addition line
would mean `total` has not been assigned yet. For a dependency/import error,
check the selected project environment rather than reinstalling the adapter.

## C: compile with debug information first

Create `debug_demo.c`:

```c
#include <stdio.h>

int main(void) {
    int left = 6;
    int right = 4;
    int total = left + right;
    printf("%d\n", total);
    return 0;
}
```

In the same directory, compile and verify normal execution:

```bash
cc -g -O0 -Wall -Wextra debug_demo.c -o debug_demo
./debug_demo
```

1. Open `debug_demo.c` and set a breakpoint on `printf`.
2. Press `Space D c`, choose **Launch file**, and enter the absolute path to the
   compiled `debug_demo` executable, not the `.c` source.
3. At the breakpoint, inspect `total = 10`, step over, and continue.
4. Recompile after changing C code. This setup deliberately does not run a
   guessed build command for arbitrary projects.

`-g` adds source/variable debug information; `-O0` keeps the beginner exercise
from being rearranged by optimization. If macOS displays a developer-tools
authorization prompt, review that prompt; this task does not require disabling
SIP. A CodeLLDB adapter-start error is different from an unverified breakpoint
caused by an outdated or non-debug executable.

## What has and has not been verified

The repository checks cover config syntax, adapter configuration from the
locked LazyVim revision, and remapping debugger shortcuts without changing
the existing delete mapping. The sample programs can be checked independently.
Actual breakpoints, UI rendering, macOS authorization and Apple Silicon adapter
execution must still be exercised on the Mac with the steps above.

Sources:
- [LazyVim DAP core](https://www.lazyvim.org/extras/dap/core)
- [LazyVim Python](https://www.lazyvim.org/extras/lang/python)
- [LazyVim clangd / C debugging](https://www.lazyvim.org/extras/lang/clangd)
