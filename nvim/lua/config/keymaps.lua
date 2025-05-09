-- Keymaps are automatically loaded on the VeryLazy event
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- Clipboard mappings
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Delete to the black hole register (do not affect clipboard)
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

--macos setting<D-s>s
vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file (CMD+S workaround)" })
-- ~/.config/nvim/lua/config/keymaps.lua
-- … your other mappings above …

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
      java = { "bash", "-c", ("javac '%s' && java '%s'"):format(file, vim.fn.expand("%:t:r")) },
      rust = { "bash", "-c", "cargo run" },
      javascript = { "bash", "-c", ("node '%s'"):format(file) },
      html = { "bash", "-c", ("open '%s'"):format(file) },
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

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.5)
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

-- Define options for key mappings
local opts = { noremap = true, silent = true }

-- 📝 Commit: Opens a floating window for commit message
vim.keymap.set("n", "<leader>gm", function()
  vim.cmd("wall") -- Save all files

  -- Create a floating buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.6)
  local height = 10
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Set filetype and placeholder
  vim.api.nvim_buf_set_option(buf, "filetype", "gitcommit")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "# Type your commit message and press q to commit" })

  -- Map 'q' to commit and close
  vim.keymap.set("n", "q", function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local message = {}
    for _, line in ipairs(lines) do
      if not line:match("^#") and line:match("%S") then
        table.insert(message, line)
      end
    end
    message = table.concat(message, "\n")

    if message == "" then
      vim.notify("❌ Commit message is empty!", vim.log.levels.WARN)
      return
    end

    vim.api.nvim_win_close(win, true)
    vim.fn.system({ "git", "commit", "-m", message })
    vim.notify("✅ Commit done!", vim.log.levels.INFO)
  end, { buffer = buf, noremap = true, silent = true, desc = "Commit & Close" })
end, { desc = "📝 Git Commit (floating, press q to confirm)", noremap = true, silent = true })

-- ➕ Add: Stages all changes
vim.keymap.set("n", "<leader>ga", "<cmd>Git add .<CR>", { desc = "➕ Git Add All", noremap = true, silent = true })

-- 🔄 Checkout: Opens a prompt to enter branch or commit
vim.keymap.set("n", "<leader>gh", function()
  vim.api.nvim_feedkeys(":Git checkout ", "n", false)
end, { desc = "🔄 Git Checkout (prompt)", noremap = true, silent = true })

-- 🔀 Merge: Opens a prompt to enter branch to merge
vim.keymap.set("n", "<leader>gx", function()
  vim.api.nvim_feedkeys(":Git merge ", "n", false)
end, { desc = "🔀 Git Merge (prompt)", noremap = true, silent = true })

-- 🔄 Pull: Pulls latest changes with rebase
vim.keymap.set(
  "n",
  "<leader>gr",
  "<cmd>Git pull --rebase<CR>",
  { desc = "🔄 Git Pull (rebase)", noremap = true, silent = true }
)

-- 🚀 Push: Pushes commits to the remote repository
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "🚀 Git Push", noremap = true, silent = true })

-- Function to toggle Git status in a floating window
local git_status_win = nil
local git_status_buf = nil

function ToggleGitStatus()
  if git_status_win and vim.api.nvim_win_is_valid(git_status_win) then
    vim.api.nvim_win_close(git_status_win, true)
    git_status_win = nil
    git_status_buf = nil
  else
    vim.cmd("wall") -- Save all files

    -- Create a new buffer
    git_status_buf = vim.api.nvim_create_buf(false, true)

    -- Define window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create the floating window
    git_status_win = vim.api.nvim_open_win(git_status_buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })

    -- Run Git status and set the output to the buffer
    local handle = io.popen("git status")
    local result = handle:read("*a")
    handle:close()
    vim.api.nvim_buf_set_lines(git_status_buf, 0, -1, false, vim.split(result, "\n"))
    vim.api.nvim_buf_set_option(git_status_buf, "filetype", "git")

    -- Set buffer-local keymap for 'q' to close the floating window
    vim.api.nvim_buf_set_keymap(git_status_buf, "n", "q", "", {
      noremap = true,
      silent = true,
      callback = function()
        if git_status_win and vim.api.nvim_win_is_valid(git_status_win) then
          vim.api.nvim_win_close(git_status_win, true)
          git_status_win = nil
          git_status_buf = nil
        end
      end,
    })
  end
end

-- Map the function to <leader>gj
vim.api.nvim_set_keymap(
  "n",
  "<leader>gj",
  "<cmd>lua ToggleGitStatus()<CR>",
  { noremap = true, silent = true, desc = "📄 Toggle Git Status" }
)
-- 🌿 Branches: Lists branches
vim.keymap.set("n", "<leader>gl", "<cmd>Git branch<CR>", { desc = "🌿 Git Branches", noremap = true, silent = true })

-- 📜 Log: Shows commit log with graph
vim.keymap.set(
  "n",
  "<leader>ge",
  "<cmd>Git log --oneline --graph<CR>",
  { desc = "📜 Git Log Graph", noremap = true, silent = true }
)

-- Function to toggle Git diff in a floating window
local git_diff_win = nil
local git_diff_buf = nil

function ToggleGitDiff()
  if git_diff_win and vim.api.nvim_win_is_valid(git_diff_win) then
    vim.api.nvim_win_close(git_diff_win, true)
    git_diff_win = nil
    git_diff_buf = nil
  else
    vim.cmd("wall") -- Save all files

    -- Create a new buffer
    git_diff_buf = vim.api.nvim_create_buf(false, true)

    -- Define window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create the floating window
    git_diff_win = vim.api.nvim_open_win(git_diff_buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })

    -- Run Git diff and set the output to the buffer
    local handle = io.popen("git diff")
    local result = handle:read("*a")
    handle:close()
    vim.api.nvim_buf_set_lines(git_diff_buf, 0, -1, false, vim.split(result, "\n"))
    vim.api.nvim_buf_set_option(git_diff_buf, "filetype", "diff")
  end
end

-- Map the function to <leader>gd
vim.api.nvim_set_keymap(
  "n",
  "<leader>gd",
  "<cmd>lua ToggleGitDiff()<CR>",
  { noremap = true, silent = true, desc = "🧾 Toggle Git Diff" }
)

-- 🕵️ Blame: Shows blame for the current file
vim.keymap.set("n", "<leader>gy", "<cmd>Git blame<CR>", { desc = "🕵️ Git Blame", noremap = true, silent = true })

local map = vim.keymap.set

map("n", "<leader>rs", function()
  vim.fn.jobstart("tmux new-session -d -s live-server 'live-server'", { detach = true })
  print("Started tmux session 'live-server' running live-server.")
end, { desc = "Start live-server in tmux session" })

vim.keymap.set("n", "<leader>rm", ":MarkdownPreview<CR>", { desc = "Markdown Preview" })
vim.keymap.set("n", "<leader>rM", ":MarkdownPreviewStop<CR>", { desc = "Stop Preview" })
