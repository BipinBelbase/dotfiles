return {
  {
    "m4xshen/hardtime.nvim",
    enabled = false,
  },

  {
    "folke/noice.nvim",
    enabled = false,
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      transparent = false,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_y = { "diff", "diagnostics", "location" },
      },
    },
  },

  {
    "folke/trouble.nvim",
    opts = {
      focus = false,
    },
  },
}
