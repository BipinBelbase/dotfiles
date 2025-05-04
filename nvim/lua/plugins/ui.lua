return {
  -- {
  -- <  "folke/noice.nvim",
  --   opts = function(_, opts)
  --     opts.presets.lsp_doc_border = true
  --   end,
  -- },
  --

  {
    "folke/lazy.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true,
      timer_interval = 1000,
      auto_close_after = 3000,
      hint_enable = false,
      hint_inline = false,
      always_trigger = false,
      select_signature_key = "<C-n>",
      handler_opts = {
        border = "rounded",
      },
      max_height = 3,
      max_width = 40,
      floating_window = true,
      floating_window_above_cur_line = true,
      doc_lines = 0,
      fix_pos = false,
      close_timeout = 4000,
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- Make Noice handle hover and signature help popups
        override = {
          ["vim.lsp.util.open_floating_preview"] = true,
          ["vim.lsp.handlers.signature_help"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false, -- turn signature help off
        },
      },
      routes = {
        {
          filter = {
            any = {
              {
                event = { "notify", "msg_show" },
                find = "No information available",
              },
              {
                event = "msg_show",
                kind = "",
                find = "written",
              },
            },
          },
          opts = {
            skip = true,
          },
        },
      },
      presets = {
        lsp_doc_border = true, -- rounded borders
        long_message_to_split = true,
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[

    ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗        
    ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝        
    ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗          
    ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝          
    ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗        
     ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝        
                                                                          
██████╗ ██████╗  ██████╗ ███████╗███████╗███████╗███████╗ ██████╗ ██████╗ 
██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔═══██╗██╔══██╗
██████╔╝██████╔╝██║   ██║█████╗  █████╗  ███████╗███████╗██║   ██║██████╔╝
██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██╔══╝  ╚════██║╚════██║██║   ██║██╔══██╗
██║     ██║  ██║╚██████╔╝██║     ███████╗███████║███████║╚██████╔╝██║  ██║
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
   ]],
        },
      },
    },
  },
}
