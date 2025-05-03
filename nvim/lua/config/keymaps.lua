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
--macos settings
vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file (CMD+S workaround)" })
do
  local float_term = { buf = nil, win = nil }

  local function close_float()
    if float_term.win and vim.api.nvim_win_is_valid(float_term.win) then
      vim.api.nvim_win_close(float_term.win, true)
      float_term.win = nil
      float_term.buf = nil
    end
  end

  local function open_float(cmd)
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
    vim.fn.termopen(cmd)
    vim.cmd("startinsert")
    vim.api.nvim_buf_set_keymap(
      float_term.buf,
      "n",
      "q",
      "<Cmd>lua close_float()<CR>",
      { nowait = true, noremap = true, silent = true }
    )
  end

  local function run_current_file()
    vim.cmd("write")
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

  vim.keymap.set("n", "<Leader>r", run_current_file, {
    desc = "▎ Run current file in floating terminal",
  })
end
