-- in lua/config/keymaps.lua
local open_term = require("lazyvim.util.terminal").open

local function run_current_file()
  vim.cmd("write")
  local ft = vim.bo.filetype
  local fname = vim.fn.expand("%")
  local stem = vim.fn.expand("%:r")
  local cmds = {
    c = { "bash", "-c", ("gcc %s -o %s && ./%s"):format(fname, stem, stem) },
    cpp = { "bash", "-c", ("g++ %s -o %s && ./%s"):format(fname, stem, stem) },
    python = { "bash", "-c", ("python3 %s"):format(fname) },
    java = { "bash", "-c", ("javac %s && java %s"):format(fname, stem) },
    rust = { "bash", "-c", "cargo run" },
    javascript = { "bash", "-c", ("node %s"):format(fname) },
    html = { "bash", "-c", ("open %s"):format(fname) },
  }
  local args = cmds[ft]
  if not args then
    vim.notify("No runner for: " .. ft, vim.log.levels.WARN)
    return
  end
  open_term(args, { direction = "float", size = 20 })
end

vim.keymap.set("n", "<Leader>r", run_current_file, { desc = "Run current file" })
