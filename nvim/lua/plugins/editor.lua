return {

  -- File: ~/.config/nvim/lua/plugins/render_markdown.lua
  -- File: ~/.config/nvim/lua/plugins/render_markdown.lua
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   opts = {
  --     code = {
  --       sign = true,
  --       width = "block",
  --       right_pad = 1,
  --     },
  --     heading = {
  --       sign = true,
  --       icons = {},
  --     },
  --     checkbox = {
  --       enabled = true,
  --     },
  --   },
  --   ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  --   config = function(_, opts)
  --     require("render-markdown").setup(opts)
  --     Snacks.toggle({
  --       name = "Render Markdown",
  --       get = function()
  --         return require("render-markdown.state").enabled
  --       end,
  --       set = function(enabled)
  --         local m = require("render-markdown")
  --         if enabled then
  --           m.enable()
  --         else
  --           m.disable()
  --         end
  --       end,
  --     }):map("<leader>rn")
  --   end,
  -- },
  {
    -- flaash is disabled..............
    enabled = false,
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      search = {
        forward = true,
        multi_window = false,
        wrap = false,
        incremental = true,
      },
    },
  },

  -- ~/.config/nvim/lua/plugins/harpoon.lua
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      menu = { width = vim.api.nvim_win_get_width(0) - 4 },
      settings = {
        save_on_toggle = true,
        sync_on_toggle = false,
      },
    },
    keys = function()
      local keys = {
        -- disable LazyVim’s default "<leader>H" mapping
        { "<leader>H", false },

        -- add current file to Harpoon list
        {
          "<leader>ha",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },

        -- toggle the Harpoon quick-menu
        {
          "<leader>hh",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }
      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end

      return keys
    end,
  },
}
