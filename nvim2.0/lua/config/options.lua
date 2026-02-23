local opt = vim.opt

opt.shortmess:remove("I")
opt.termguicolors = true
opt.swapfile = false
opt.undofile = true
opt.timeoutlen = 300
opt.updatetime = 250
opt.scrolloff = 4
opt.wrap = false
opt.cursorline = false
opt.numberwidth = 2
opt.signcolumn = "yes"
opt.foldcolumn = "0"
opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'
opt.formatoptions:remove("o")

pcall(function()
  opt.winborder = "rounded"
end)

-- Keep LazyVim's prettier behavior explicit for predictable formatting setup.
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"
