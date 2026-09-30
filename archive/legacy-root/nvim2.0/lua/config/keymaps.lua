local map = vim.keymap.set

-- Keep search and scrolling centered.
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "J", "mzJ`z", { desc = "Join line below without moving cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clipboard and register helpers.
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })

map(
  "n",
  "<leader>fr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor" }
)
map("n", "Q", "<nop>", { desc = "Disable Ex mode" })

map("n", "<leader>e", function()
  require("snacks").picker.explorer()
end, { desc = "Explorer (cwd)" })

map("n", "<C-f>", function()
  if not vim.env.TMUX then
    vim.notify("Not inside a tmux session", vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("tmux") == 0 or vim.fn.executable("tmux-sessionizer") == 0 then
    vim.notify("tmux or tmux-sessionizer is not available", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstart({ "tmux", "new-window", "tmux-sessionizer" }, { detach = true })
end, { desc = "Tmux Sessionizer" })

if vim.fn.has("unix") == 1 then
  map("n", "<leader>fx", "<cmd>silent !chmod +x %<CR>", { desc = "Make current file executable" })
end

map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
