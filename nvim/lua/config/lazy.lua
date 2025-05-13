local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- after you preload lazy.nvim, before require("lazy").setup
vim.lsp.handlers["$/progress"] = function() end
-- completely no-ops any LSP progress updates:
require("lazy").setup({

    change_detection = { notify = false },
    spec = {
        -- add LazyVim and import its plugins
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- import/override with your plugins
        { import = "lazyvim.plugins.extras.linting.eslint" },
        { import = "lazyvim.plugins.extras.formatting.prettier" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "plugins" },
    },
    ui = {
        border = "rounded",
        backdrop = 60,
    },
    defaults = {
        -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
        lazy = false,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = {
        enabled = false, -- check for plugin updates periodically
        notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- 1) Only show ERROR diagnostics (hide WARN, INFO, HINT)
    vim.diagnostic.config({
        -- filter out anything below Error
        severity = { min = vim.diagnostic.severity.ERROR },
        -- optionally keep signs in the gutter only for Errors
        signs = { severity = { min = vim.diagnostic.severity.ERROR } },
        -- disable virtual-text pop-up inline
        virtual_text = false,
        -- you can still hover for details if you like
        float = { severity = { min = vim.diagnostic.severity.ERROR } },
    }),
    -- ─────────────────────────────────────────────────────────────────────────────
})
