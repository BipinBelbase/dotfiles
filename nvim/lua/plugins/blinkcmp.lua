require("blink.cmp").setup({
  completion = {
    autocomplete = false, -- Disable automatic completion
    trigger = {
      show_on_blocked_trigger_characters = {}, -- Prevent completion on newline, tab, or space
    },
  },
  windows = {
    autocomplete = {
      border = "rounded",
      draw = "none", -- Hide the autocomplete menu
    },
    documentation = {
      border = "rounded",
      draw = "none", -- Hide the documentation window
    },
    signature_help = {
      border = "rounded",
      draw = "none", -- Hide the signature help window
    },
    ghost_text = {
      enabled = false, -- Disable ghost text
    },
  },
  keymap = {
    preset = "super-tab", -- Use super-tab for completion
  },
})
