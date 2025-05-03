return {
  {

    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({
        bind = true, -- Automatically binds the function signature to keymap
        hint_enable = false, -- Show function signature hint
        toggle_key = "<C-k>", -- Key to toggle the signature help
        floating_window = true, -- Show signature in a floating window
        floating_window_above_cur_line = true, -- Floating window appears above current line
        fix_pos = false, -- Whether to fix the position of the signature
        transparency = 50, -- Adjust transparency of floating window
        max_width = 60, -- Max width of the signature floating window
        max_height = 10, -- Max height of the signature floating window
        handler_opts = {
          border = "rounded", -- Add rounded corners to the signature popup
        },
      })
    end,
  },
}
