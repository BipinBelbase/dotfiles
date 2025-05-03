return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat", -- Ensure blink.compat is treated as a dependency of blink.cmp
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
      "ray-x/cmp-sql",
    },
    version = "1.*",
    lazy = true, -- Lazy loading to make sure it loads only when required
    opts = {
      keymap = {
        preset = "super-tab",
        ["super-tab"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
        nerd_font_variant = "mono",
        completion = {
          border = "rounded", -- Add rounded border to the completion menu
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          winblend = vim.o.pumblend,
        },
        documentation = {
          auto_show = false,
        },
        ghost_text = { enabled = false },
      },
      signature = {
        enabled = false,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            opts = { insert = true },
            should_show_items = function()
              return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
            end,
          },
          sql = {
            name = "sql",
            module = "blink.compat.source", -- Ensures blink.compat source is used correctly
            score_offset = -3,
            opts = {},
            should_show_items = function()
              return vim.tbl_contains({ "sql" }, vim.o.filetype)
            end,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
