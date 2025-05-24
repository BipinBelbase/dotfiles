return {
    --below installed plugins
    --1.lualine.nvim
    --2.lualine
    --3.whichkey
    --4.tokyonight
    --5.telescope
    --6.noice
    --7.snacks

    {
        "akinsho/bufferline.nvim",
        enabled = false,
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                -- instead of "auto", provide a table describing each section’s colors:

                theme = {
                    normal = {
                        a = { fg = "#ffffff", bg = "#24283b", gui = "bold" },
                        b = { fg = "#ffffff", bg = "#24283b" },
                        c = { fg = "#ffffff", bg = "#24283b" },
                    },
                    insert = { a = { fg = "#ffffff", bg = "#24283b", gui = "bold" } },
                    visual = { a = { fg = "#ffffff", bg = "#24283b", gui = "bold" } },
                    replace = { a = { fg = "#ffffff", bg = "#24283b", gui = "bold" } },
                    inactive = {
                        a = { fg = "#bbbbbb", bg = "#24283b" },
                        b = { fg = "#bbbbbb", bg = "#24283b" },
                        c = { fg = "#bbbbbb", bg = "#24283b" },
                    },
                },
                section_separators = "",
                component_separators = " | ",
                globalstatus = true,
            },
            tabline = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        function()
                            local buffers = {}
                            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                                if vim.api.nvim_buf_is_loaded(bufnr) then
                                    local is_current = bufnr == vim.api.nvim_get_current_buf()
                                    local is_modified =
                                        vim.api.nvim_get_option_value("modified", { buf = bufnr })

                                    if is_current or is_modified then
                                        local name = vim.fn.fnamemodify(
                                            vim.api.nvim_buf_get_name(bufnr),
                                            ":t"
                                        )
                                        if name == "" then
                                            name = "[No Name]"
                                        end
                                        if is_modified then
                                            name = name .. " ●"
                                        end
                                        if is_current then
                                            name = "%#TabLineSel#["
                                                .. ""
                                                .. name
                                                .. ""
                                                .. "]%#TabLine#"
                                        end
                                        table.insert(buffers, name)
                                    end
                                end
                            end
                            return table.concat(buffers, " │ ")
                        end,
                        color = { gui = "bold" },
                    },
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = { { "filename", path = 3 } },
                lualine_x = {
                    {
                        function()
                            local reg = vim.fn.reg_recording()
                            if reg ~= "" then
                                return "Recording @" .. reg
                            end
                            return nil
                        end,
                        cond = function()
                            return vim.fn.reg_recording() ~= ""
                        end,
                    },
                },
                lualine_y = { "diff", "diagnostics", "location" },
                lualine_z = { { "progress" } },
            },
        },
        config = function(_, opts)
            require("lualine").setup(opts)
            -- make sure no other bg bleeds through:
            vim.cmd("highlight Normal guibg=NONE")
            vim.cmd([[
      highlight TabLineSel gui=bold guifg=#ffffff guibg=#24283b
      highlight TabLine gui=none guifg=#888888 guibg=#24283b
    ]])
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {
            show_help = false, -- ❌ disables the bottom help text :contentReference[oaicite:0]{index=0}
            -- 2) don’t echo the current key in the cmdline at all
            show_keys = false, -- ❌ disables “You pressed: <leader>” :contentReference[oaicite:1]{index=1}

            -- 3) optionally, override the arrow / back icons to be empty
            icons = {
                mappings = false, -- disable all mapping icons :contentReference[oaicite:3]{index=3}
                rules = false, -- disable icon rules (autodetected icons) :contentReference[oaicite:4]{index=4}
                separator = "",
                colors = false, -- disable colored highlighting for icons :contentReference[oaicite:5]{index=5}
                -- keys → these are the glyphs for special keys in the popup
                keys = {
                    BS = "", -- blank out the Backspace (“go up one level”) glyph
                    Esc = "", -- blank out the Escape (“close”) glyph
                },
                -- you can also blank scroll icons if you like:
                scroll_down = "",
                scroll_up = "",
            },
            win = {
                -- border style: "none" | "single" | "double" | "rounded" | …
                border = "rounded", -- ✔️ valid :contentReference[oaicite:0]{index=0}
                -- prevent popup overlapping your cursor
                no_overlap = true, -- ✔️ valid :contentReference[oaicite:1]{index=1}
                -- extra window padding [top/bottom, right/left]
                padding = { 0, 0, 0, 0 }, -- ✔️ valid :contentReference[oaicite:2]{index=2}
                -- show a title and its position: "left" | "center" | "right"
                title = true, -- ✔️ valid :contentReference[oaicite:3]{index=3}
                title_pos = "center", -- ✔️ valid :contentReference[oaicite:4]{index=4}
                -- z-index of the floating win
                zindex = 1000, -- ✔️ valid :contentReference[oaicite:5]{index=5}
                -- Vim’s buffer-local & window-local options
                bo = {}, -- ✔️ valid :contentReference[oaicite:6]{index=6}
                -- wo = { -- ✔️ valid :contentReference[oaicite:7]{index=7}
                --     -- here you can set winblend, winhighlight, etc.
                --     winblend = 10,
                -- },
                -- you can also set col, row, width, height here (see comments in defaults)
                -- col = 0,
                -- row = math.huge,
                width = { min = 10, max = 26 },
                height = { min = 3, max = 18 },
            },

            layout = {
                align = "left",
                -- spacing between columns
                spacing = 0, -- ✔️ valid :contentReference[oaicite:8]{index=8}
                -- you can also control column width/height here
                width = { min = 11, max = 27 },
                height = { min = 4, max = 19 },
            },
        },
    },
    --vim game for improving typing speed
    -- {
    --     "ThePrimeagen/vim-be-good",
    --     cmd = { "VimBeGood" }, -- Load only when you run VimBeGood (<leader>gt)
    -- },
    {
        { "j-hui/fidget.nvim", enabled = false },
    },

    -- -- add gruvbox
    -- { "ellisonleao/gruvbox.nvim" },
    -- {
    --     "LazyVim/LazyVim",
    --     opts = {
    --         colorscheme = "gruvbox",
    --     },
    -- },
    {
        "folke/tokyonight.nvim",
        opts = {
            transparent = true,
            on_highlights = function(hl, c)
                hl.TabLine = { fg = "#888888", bg = "#24283b" } -- Dimmed buffers
                hl.TabLineSel = { fg = "#FFFFFF", bg = "#24283b", bold = true } -- Current buffer
                hl.TabLineModified = { fg = "#888888", bg = "#24283b" }
            end,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
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
            cmdline = {
                view = "cmdline", -- use the classic bottom style view
            },
            views = {
                cmdline = {
                    position = {
                        row = -1, -- this puts it at the bottom
                        col = 0,
                    },
                    size = {
                        width = "100%",
                    },
                },
            },
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
            dashboard = { enabled = false },
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
                    },
                },
            },
        },
    },

    --guii ii i ii i ii
    -- this is for the gui of opening if you want
    --     {
    --         "folke/snacks.nvim",
    --         opts = {
    --             picker = {
    --                 sources = {
    --                     explorer = {
    --                         layout = {
    --                             layout = {
    --                                 width = 0.22, -- absolute width of 25 columns :contentReference[oaicite:0]{index=0}
    --                                 border = "rounded",
    --                                 -- you can also set height here if you like:
    --                                 -- height = 20,
    --                             },
    --                             -- you could also tweak position:
    --                             -- layout = { width = 25, height = 20, position = "left" },
    --                         },
    --                         win = {
    --                             list = {
    --                                 border = "rounded", -- ← rounded border on the file list :contentReference[oaicite:2]{index=2}
    --                             },
    --                         },
    --
    --                         -- 3) Keep other defaults (hidden, auto_close, etc.)
    --                         hidden = true,
    --                         -- optional: always_focus_input, jump, follow_file, etc.
    --                     },
    --                 },
    --             },
    --             dashboard = {
    --                 preset = {
    --                     header = [[
    --
    --     ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗
    --     ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝
    --     ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗
    --     ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝
    --     ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗
    --      ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝
    -- ██████╗ ██████╗  ██████╗ ███████╗███████╗███████╗███████╗ ██████╗ ██████╗
    -- ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔═══██╗██╔══██╗
    -- ██████╔╝██████╔╝██║   ██║█████╗  █████╗  ███████╗███████╗██║   ██║██████╔╝
    -- ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██╔══╝  ╚════██║╚════██║██║   ██║██╔══██╗
    -- ██║     ██║  ██║╚██████╔╝██║     ███████╗███████║███████║╚██████╔╝██║  ██║
    -- ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
    --    ]],
    --                 },
    --
    --                 sections = {
    --                     { section = "header", padding = 1 },
    --                     { pane = 2, section = "keys", gap = 0, padding = 1 },
    --                     { section = "startup", padding = 0 },
    --                 },
    --
    --                 layout = {
    --                     type = "float",
    --                     border = "rounded",
    --                     width = math.floor(vim.o.columns * 0.6),
    --                     height = math.floor(vim.o.lines * 0.3),
    --                     row = 0.3,
    --                     col = 0.2,
    --                 },
    --
    --                 button_opts = {
    --                     border = "rounded",
    --                     padding = { left = 1, right = 1 },
    --                     position = "center",
    --                 },
    --             },
    --         },
    --     },
}
