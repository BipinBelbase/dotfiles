vim.keymap.set("n", "<leader><leader>", "<nop>")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-f>", function()
    local tmux = os.getenv("TMUX")
    if tmux then
        os.execute("tmux neww tmux-sessionizer")
    else
        print("Not in a tmux session")
    end
end, { desc = "Smart Tmux Sessionizer", noremap = true, silent = true })

vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>p", "<Nop>", { silent = true, remap = false })
vim.keymap.set({ "n", "v" }, "<leader>pp", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("x", "<leader>pn", [["_dP]], { desc = "Paste without storing" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })

--netrw settings
vim.opt.autochdir = true
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
function ToggleNetrw()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if ft == "netrw" then
        vim.cmd("bd") -- Close Netrw
    else
        vim.cmd("Explore") -- Open Netrw in current window
    end
end

vim.api.nvim_set_keymap(
    "n",
    "<leader>pv",
    ":lua ToggleNetrw()<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>pv",
    ":lua ToggleNetrw()<CR>",
    { noremap = true, silent = true }
)
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 60

vim.keymap.set("n", "<leader>cb", function()
    vim.diagnostic.open_float()
end, { desc = "diagonistic current file" })
-- Delete to the black hole register (do not affect clipboard)
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--greatest remap
vim.keymap.set("n", "<CR>", "<C-d>zz", { noremap = true }) -- Enter scrolls down
vim.keymap.set("n", "<BS>", "<C-u>zz", { noremap = true }) -- Backspace scrolls up
vim.keymap.set("v", "<CR>", "<C-d>zz", { noremap = true }) -- Enter scrolls down
-- new added one
pcall(vim.keymap.del, "x", "<BS>")
vim.keymap.set("x", "<BS>", "16k", { noremap = true, silent = true })

-- vim.keymap.set("x", "\\", "<C-u>zz", { noremap = true, silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>j", vim.diagnostic.goto_next, { desc = "Next ERROR LIST" })
vim.keymap.set("n", "<leader>k", vim.diagnostic.goto_prev, { desc = "Prev ERROR LIST" })
vim.keymap.set(
    "n",
    "<leader>fr",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Find and Replace" }
)
vim.keymap.set("n", "Q", "<nop>")
--macos setting<D-s>s
vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file (CMD+S workaround)" })

do
    -- state for the float
    local float_term = { buf = nil, win = nil }

    -- close existing float
    local function close_float()
        if float_term.win and vim.api.nvim_win_is_valid(float_term.win) then
            vim.api.nvim_win_close(float_term.win, true)
            float_term.win = nil
            float_term.buf = nil
        end
    end

    -- open (or re-open) the float and run `cmd`
    local function open_float(cmd)
        close_float()

        -- scratch buffer
        float_term.buf = vim.api.nvim_create_buf(false, true)

        -- center & size
        local w = math.floor(vim.o.columns * 0.8)
        local h = math.floor(vim.o.lines * 0.5)
        local r = math.floor((vim.o.lines - h) / 2)
        local c = math.floor((vim.o.columns - w) / 2)

        float_term.win = vim.api.nvim_open_win(float_term.buf, true, {
            relative = "editor",
            width = w,
            height = h,
            row = r,
            col = c,
            style = "minimal",
            border = "rounded",
        })

        -- **THIS** launches your shell command
        -- vim.fn.termopen(cmd)

        vim.api.nvim_call_function("termopen", { cmd })
        -- enter terminal mode
        vim.cmd("startinsert")

        -- bind `q` to close
        vim.api.nvim_buf_set_keymap(
            float_term.buf,
            "n",
            "q",
            "<Cmd>lua close_float()<CR>",
            { nowait = true, noremap = true, silent = true }
        )
    end

    vim.keymap.set({ "n", "v" }, "<leader>fs", "<cmd>w<cr>", { desc = "Save File" })
    -- pick the right compile/run command and fire it
    local function run_current_file()
        vim.cmd("write") -- save

        local ft = vim.bo.filetype
        local file = vim.fn.expand("%:p")
        local stem = vim.fn.expand("%:p:r")

        local cmd_map = {
            c = { "bash", "-c", ("gcc '%s' -o '%s' && '%s'"):format(file, stem, stem) },
            cpp = { "bash", "-c", ("g++ '%s' -o '%s' && '%s'"):format(file, stem, stem) },
            python = { "bash", "-c", ("python3 '%s'"):format(file) },
            java = {
                "bash",
                "-c",
                ("javac '%s' && java '%s'"):format(file, vim.fn.expand("%:t:r")),
            },
            rust = { "bash", "-c", "cargo run" },
            javascript = { "bash", "-c", ("node '%s'"):format(file) },
            html = { "bash", "-c", ("open '%s'"):format(file) },

            typescript = { "bash", "-c", ("npx ts-node '%s'"):format(file) },
            go = { "bash", "-c", ("go run '%s'"):format(file) },
            lua = { "bash", "-c", ("lua '%s'"):format(file) },
            sh = { "bash", "-c", ("bash '%s'"):format(file) },
            zsh = { "bash", "-c", ("zsh '%s'"):format(file) },
            php = { "bash", "-c", ("php '%s'"):format(file) },
            ruby = { "bash", "-c", ("ruby '%s'"):format(file) },
            perl = { "bash", "-c", ("perl '%s'"):format(file) },
            make = {
                "bash",
                "-c",
                ("make -C '%s' %s"):format(
                    vim.fn.fnamemodify(file, ":h"),
                    vim.fn.fnamemodify(file, ":t:r")
                ),
            },
            dockerfile = {
                "bash",
                "-c",
                ("docker build -t %s '%s'"):format(stem, vim.fn.fnamemodify(file, ":h")),
            },
        }

        local cmd = cmd_map[ft]
        if not cmd then
            vim.notify("▎ No runner for filetype: " .. ft, vim.log.levels.WARN)
            return
        end

        open_float(cmd)
    end

    -- map Space→r to run
    vim.keymap.set("n", "<Leader>rr", run_current_file, {
        desc = "▎ Run current file in floating terminal",
    })
end

-- Floating Terminal with <leader>tt (Space + t + t)
-- Store floating terminal state
local float_term = { buf = nil, win = nil }
-- Function to close the terminal
local function close_float()
    if float_term.win and vim.api.nvim_win_is_valid(float_term.win) then
        vim.api.nvim_win_close(float_term.win, true)
        float_term.win = nil
        float_term.buf = nil
    end
end

-- Function to open terminal in a floating window
local function open_floating_terminal()
    close_float()
    float_term.buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.7)
    local height = math.floor(vim.o.lines * 0.60)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    float_term.win = vim.api.nvim_open_win(float_term.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
    -- Open terminal in the buffer
    vim.fn.termopen(os.getenv("SHELL") or "bash")
    vim.cmd("startinsert")
    -- Close with 'q'
    vim.api.nvim_buf_set_keymap(float_term.buf, "n", "q", "", {
        callback = close_float,
        noremap = true,
        silent = true,
    })
end

-- 🧠 Keybinding to <leader>tt (space t t)
vim.keymap.set("n", "<leader>tt", open_floating_terminal, {
    desc = "▎ Open floating terminal",
})

local map = vim.keymap.set
map("n", "<leader>rs", function()
    vim.fn.jobstart("tmux new-session -d -s live-server 'live-server'", { detach = true })
    print("Started tmux session 'live-server' running live-server.")
end, { desc = "Start live-server in tmux session" })

-- Simply map <leader>fx to :!chmod +x %<CR>
vim.keymap.set("n", "<leader>fx", ":!chmod +x %<CR>", { desc = "Make file executable (+x)" })
vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })
-- Resize splits using Ctrl + Arrow Keys
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase Height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease Height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease Width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase Width" })

vim.keymap.set("n", "<C-k>", function()
    require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "Toggle LSP Signature" })

vim.keymap.set("n", "<leader>e", function()
    Snacks.picker.explorer()
end, { desc = "Open Snacks Explorer" })
