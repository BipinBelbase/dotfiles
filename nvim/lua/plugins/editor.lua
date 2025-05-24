return {
    --currently have
    --1.harpoon2
    --2.undotree
    --3.blink-cmp (auto-completion)
    --4.vim-dab-ui(sql database)
    --5.nvim-treesitter

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "html",
                "css",
                "javascript",
                "typescript",
                "tsx", -- React (JSX/TSX)
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "vim",
                "yaml",
                "java",
                "c",
                "cpp",
            },
        },
    },
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

    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
            {
                "kristijanhusak/vim-dadbod-completion",
                ft = { "sql", "mysql", "plsql" },
                lazy = true,
            }, -- Optional
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,

        opts = {
            auto_execute = true, -- auto-run selected query
            border = "rounded", -- floating window style
            save_location = vim.fn.stdpath("data") .. "/dadbod-ui-queries", -- persistent saved queries
        },
    },
    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
                ghost_text = { enabled = false },
                menu = vim.tbl_deep_extend(
                    "force",
                    opts.completion and opts.completion.menu or {},
                    {
                        border = "rounded",
                        winblend = 0,
                        draw = {
                            columns = {
                                { "label", "label_description", gap = 1 },
                                { "kind_icon", "kind" },
                            },
                        },
                    }
                ),
                documentation = vim.tbl_deep_extend(
                    "force",
                    opts.completion and opts.completion.documentation or {},
                    {
                        auto_show = false,
                        window = vim.tbl_deep_extend(
                            "force",
                            opts.completion
                                    and opts.completion.documentation
                                    and opts.completion.documentation.window
                                or {},
                            {
                                border = "rounded",
                                winblend = 0,
                            }
                        ),
                    }
                ),
            })

            -- 2) Keymaps must be at the top level, not under `completion`
            opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
                -- set to 'none' to disable the 'default' preset
                preset = "super-tab",
                -- ["super-tab"] = { "accept", "fallback" },
                ["<S-Tab"] = { "select_next", "fallback" },
                ["<C-y"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },

                -- disable these defaults
                ["<C-e>"] = {},
                ["<C-space>"] = {},
            })
            opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
                window = vim.tbl_deep_extend(
                    "force",
                    opts.signature and opts.signature.window or {},
                    {
                        border = "rounded",
                        winblend = 0,
                    }
                ),
            })
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            menu = { width = vim.api.nvim_win_get_width(0) - 4 },
            settings = {
                save_on_toggle = true,
                sync_on_toggle = false,
                key = function()
                    return vim.fn.getcwd()
                end,
                -- db = require("harpoon.persist.sqlite"), -- use SQLite to persist
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
    {
        "mbbill/undotree",
        keys = {
            { "<space>cu", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
        },
        config = function()
            vim.o.undofile = true
            vim.o.undodir = vim.fn.stdpath("data") .. "/undodir"
            vim.fn.mkdir(vim.o.undodir, "p")
        end,
    },
}
