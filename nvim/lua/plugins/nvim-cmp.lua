return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        ghost_text = { enabled = false },
        menu = vim.tbl_deep_extend("force", opts.completion and opts.completion.menu or {}, {
          border = "rounded",
          winblend = 0,
        }),
        documentation = vim.tbl_deep_extend("force", opts.completion and opts.completion.documentation or {}, {
          auto_show = false,
          window = vim.tbl_deep_extend(
            "force",
            opts.completion and opts.completion.documentation and opts.completion.documentation.window or {},
            {
              border = "rounded",
              winblend = 0,
            }
          ),
        }),
      })

      -- 2) Keymaps must be at the top level, not under `completion`
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        -- set to 'none' to disable the 'default' preset
        preset = "super-tab",
        -- ["super-tab"] = { "accept", "fallback" },
        ["<S-Tab"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        -- disable these defaults
        ["<C-e>"] = {},
        ["<C-space>"] = {},
      })
      opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
        window = vim.tbl_deep_extend("force", opts.signature and opts.signature.window or {}, {
          border = "rounded",
          winblend = 0,
        }),
      })
    end,
  },
}
