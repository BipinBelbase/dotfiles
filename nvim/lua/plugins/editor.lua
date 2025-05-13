return {

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
