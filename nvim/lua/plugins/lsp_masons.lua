return {
    --available below
    --1.mason.nvim
    --2.mason-tool-installer
    --3.lsp-signature.nvim
    --4.nvim-lspconfig

    {
        "L3MON4D3/LuaSnip",
        -- Load friendly-snippets automatically when LuaSnip starts
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load({
                -- Only load these languages for faster startup; comment out lines to load more
                include = { "python", "javascript", "typescript", "c" },
                -- exclude = { "rust", "go" },  -- example of how to skip languages
            })
        end,
    },
    {
        "rafamadriz/friendly-snippets",
    },

    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            inlay_hints = { enabled = false },
            ---@type lspconfig.options
            servers = {
                tsserver = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayVariableTypeHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayVariableTypeHints = true,
                            },
                        },
                    },
                },
            },
            diagnostics = {
                underline = false, -- ⛔ disable underlines
                signs = true,
                virtual_text = false,

                -- This shows the inline text when errors founds
                -- virtual_text = {
                --     severity = vim.diagnostic.severity.ERROR, -- only red (errors)
                --     spacing = 0,
                --     source = "if_many", -- show source if many
                -- },
                update_in_insert = false,
                severity_sort = true,
            },
        },
    },
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
    -- 1) Mason core
    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    -- 2) Mason Tool Installer wraps mason.nvim to install *any* Mason package
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            -- list all your Mason-installed tools here:
            ensure_installed = {
                "ast_grep", -- AST querying                        :contentReference[oaicite:0]{index=0}
                "autoflake", -- Python import cleanup               :contentReference[oaicite:1]{index=1}
                "clangd", -- C/C++ LSP                           :contentReference[oaicite:2]{index=2}
                "codelldb", -- Debug Adapter Protocol              :contentReference[oaicite:3]{index=3}
                -- "cssls", -- CSS LSP                             :contentReference[oaicite:4]{index=4}
                "eslint", -- JavaScript/TypeScript linting       :contentReference[oaicite:5]{index=5}
                "flake8", -- Python linting                      :contentReference[oaicite:6]{index=6}
                -- "jdtls", -- Java LSP                            :contentReference[oaicite:7]{index=7}
                -- "jsonls", -- JSON LSP                            :contentReference[oaicite:8]{index=8}
                "lua_ls", -- Lua LSP                             :contentReference[oaicite:9]{index=9}
                -- "markdown-toc", -- Markdown TOC generator              :contentReference[oaicite:10]{index=10}
                -- "markdownlint-cli2", -- Markdown linting                    :contentReference[oaicite:11]{index=11}
                -- "marksman", -- Markdown LSP                        :contentReference[oaicite:12]{index=12}
                "prettier", -- Code formatter                      :contentReference[oaicite:13]{index=13}
                "pyright", -- Python LSP                          :contentReference[oaicite:14]{index=14}
                "ruff", -- Python linter                       :contentReference[oaicite:15]{index=15}
                -- "rust_analyzer", -- Rust LSP                            :contentReference[oaicite:16]{index=16}
                "selene", -- Lua linter                          :contentReference[oaicite:17]{index=17}
                "shellcheck", -- Shell script linting                :contentReference[oaicite:18]{index=18}
                -- "shfmt", -- Shell script formatting             :contentReference[oaicite:19]{index=19}
                -- "sqlfluff", -- SQL linter/formatter                :contentReference[oaicite:20]{index=20}
                "stylua", -- Lua formatter                       :contentReference[oaicite:21]{index=21}
                -- "tailwindcss", -- Tailwind CSS LSP                    :contentReference[oaicite:22]{index=22}
                "ts_ls", -- TypeScript LSP (typescript-language-server) :contentReference[oaicite:23]{index=23}
                "vtsls", -- Vue TS LSP                          :contentReference[oaicite:24]{index=24}
            },
            -- automatically run installer on startup
            run_on_start = true,
            -- keep things fast by not auto-updating
            auto_update = false,
        },
        config = function(_, opts)
            require("mason-tool-installer").setup(opts)
        end,
    },
}
