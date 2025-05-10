return {
    -- tools

    {
        "ray-x/lsp_signature.nvim",
        -- event = "InsertEnter",
        event = "LspAttach",
        opts = {
            bind = true,
            timer_interval = 200,
            auto_close_after = 3,
            hint_enable = false,
            always_trigger = false,
            select_signature_key = "<C-n>",
            handler_opts = {
                border = "rounded",
            },
            max_height = 3,
            max_width = 40,
            floating_window = true,
            floating_window_above_cur_line = true,
            doc_lines = 3,
            fix_pos = false,
            close_timeout = 3000,
        },
    },
    -- lua/plugins/mason.lua
    -- Mason core
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "flake8",
            },
        },
    },
    -- Bridge Mason ↔ lspconfig: *this* is where ensure_installed lives
    {
        "mason-org/mason-lspconfig.nvim",
        version = "1.32.0",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "pyright",
                "clangd",
                "jdtls",
                "lua_ls",
                "rust_analyzer",
                "eslint",
            },
        },
        -- Other plugins...
    },
}
