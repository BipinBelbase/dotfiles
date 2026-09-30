local function extend_unique(list, items)
  local seen = {}
  for _, value in ipairs(list) do
    seen[value] = true
  end

  for _, value in ipairs(items) do
    if not seen[value] then
      table.insert(list, value)
      seen[value] = true
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        underline = true,
        virtual_text = false,
        update_in_insert = false,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E ",
            [vim.diagnostic.severity.WARN] = "W ",
            [vim.diagnostic.severity.INFO] = "I ",
            [vim.diagnostic.severity.HINT] = "H ",
          },
        },
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
      },
    },
  },

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

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      extend_unique(opts.ensure_installed, {
        "jsonls",
        "lua_ls",
        "pyright",
        "ruff",
        "rust_analyzer",
        "vtsls",
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      extend_unique(opts.ensure_installed, {
        "eslint_d",
        "prettier",
        "shfmt",
        "stylua",
      })

      opts.run_on_start = true
      opts.auto_update = false
    end,
  },
}
