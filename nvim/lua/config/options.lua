-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--vim.opt.termguicolors = true
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"
vim.opt.swapfile = false -- No `.swp` files
vim.opt.timeoutlen = 100
vim.opt.scrolloff = 8
-- vim.opt.colorcolumn = "79" -- Show a line at 80 characters

vim.cmd([[
  highlight ColorColumn ctermbg=0 guibg=#2a2a2a
]])
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Undo (Ctrl+z)
vim.keymap.set("i", "<C-z>", "<Esc>u", { noremap = true, silent = true })

-- Redo (Ctrl+y and Ctrl+Shift+z)
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-y>", "<Esc><C-r>i", { noremap = true, silent = true })

-- Select all (Ctrl+a)
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
