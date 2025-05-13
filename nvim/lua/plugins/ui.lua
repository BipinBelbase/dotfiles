return {

    -- ~/.config/nvim/lua/plugins/disabled.lua
    {
        { "j-hui/fidget.nvim", enabled = false },
    },
    -- in lua/plugins/colorscheme.lua
    {
        {
            "folke/tokyonight.nvim",
            opts = {
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                },
            },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        keys = {
            {
                "<leader>fF",
                function()
                    require("telescope.builtin").find_files(
                        require("telescope.themes").get_dropdown({
                            cwd = vim.fn.expand("~"),
                            prompt_title = "Find Files in Home (~)",
                            hidden = true,
                            previewer = true,
                            layout_config = {
                                width = 0.8,
                                height = 0.8,
                            },
                        })
                    )
                end,
                desc = "Find Files from Home (~)",
            },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- Make Noice handle hover and signature help popups
                progress = { enabled = false },
                override = {
                    ["vim.lsp.util.open_floating_preview"] = true,
                    ["vim.lsp.handlers.signature_help"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                signature = {
                    enabled = false, -- turn signature help off
                },
            },
            notify = {
                timeout = 5000,
            },
            scroll = {
                enabled = false,
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
            picker = {
                sources = {
                    explorer = {
                        layout = {
                            layout = {
                                width = 0.22, -- absolute width of 25 columns :contentReference[oaicite:0]{index=0}
                                border = "rounded",
                                -- you can also set height here if you like:
                                -- height = 20,
                            },
                            -- you could also tweak position:
                            -- layout = { width = 25, height = 20, position = "left" },
                        },
                        win = {
                            list = {
                                border = "rounded", -- ← rounded border on the file list :contentReference[oaicite:2]{index=2}
                            },
                        },

                        -- 3) Keep other defaults (hidden, auto_close, etc.)
                        hidden = true,
                        -- optional: always_focus_input, jump, follow_file, etc.
                    },
                },
            },
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

                sections = {
                    { section = "header", padding = 1 },
                    { pane = 2, section = "keys", gap = 0, padding = 1 },
                    { section = "startup", padding = 0 },
                },

                layout = {
                    type = "float",
                    border = "rounded",
                    width = math.floor(vim.o.columns * 0.6),
                    height = math.floor(vim.o.lines * 0.3),
                    row = 0.3,
                    col = 0.2,
                },

                button_opts = {
                    border = "rounded",
                    padding = { left = 1, right = 1 },
                    position = "center",
                },
            },
        },
    },
}
