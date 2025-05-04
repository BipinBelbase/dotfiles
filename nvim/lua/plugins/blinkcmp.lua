-- ~/.config/nvim/lua/plugins/cmp.lua
return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- add a border to both the completion and docs popups
      opts.window = {
        completion = require("cmp").config.window.bordered(),
        documentation = require("cmp").config.window.bordered(),
      }
    end,
  },
}
