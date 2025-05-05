return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    config = function()
      vim.keymap.set("n", "<leader>gt", "<cmd>Git<CR>", { desc = "󰊢 Fugitive: Git Status", silent = true })
    end,
  },
}
