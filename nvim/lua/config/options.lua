--for the neovim default text to showups

vim.opt.shortmess:remove("I")
vim.opt.termguicolors = true
-- fully opaque completion menu
vim.opt.pumblend = 0
-- fully opaque floating docs
vim.opt.winblend = 0
vim.opt.clipboard = ""
vim.opt.cursorline = false
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"

vim.opt.swapfile = false -- No `.swp` files
vim.opt.timeoutlen = 100
vim.opt.scrolloff = 8
-- vim.opt.colorcolumn = "79" -- Show a line at 80 characters
-- vim.cmd([[
--   highlight ColorColumn ctermbg=0 guibg=#2a2a2a
-- ]])

vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.winborder = "rounded"
-- Redo (Ctrl+y)
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true })
-- Select all (Ctrl+a)
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.opt.numberwidth = 1
vim.opt.foldcolumn = "0"
vim.opt.signcolumn = "yes" -- or "no" if you want to completely remove

-- this is gonna , not put comment in new line

vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'
vim.opt.formatoptions:remove("o")
