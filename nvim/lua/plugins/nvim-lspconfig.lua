return {
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
                virtual_text = {
                    severity = vim.diagnostic.severity.ERROR, -- only red (errors)
                    spacing = 2,
                    source = "if_many", -- show source if many
                },
                signs = true,
                update_in_insert = false,
                severity_sort = true,
            },
        },
    },
}
