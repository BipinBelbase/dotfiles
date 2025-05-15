-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- vim.cmd("Copilot disable")
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    callback = function()
        --this is the life gap in the left insde the " what ever
        local separator = " ▎"
        vim.opt.statuscolumn = '%s%=%#LineNr4#%{(v:relnum >= 4)?v:relnum."'
            .. separator
            .. '":""}'
            .. '%#LineNr3#%{(v:relnum == 3)?v:relnum."'
            .. separator
            .. '":""}'
            .. '%#LineNr2#%{(v:relnum == 2)?v:relnum."'
            .. separator
            .. '":""}'
            .. '%#LineNr1#%{(v:relnum == 1)?v:relnum."'
            .. separator
            .. '":""}'
            .. '%#LineNr0#%{(v:relnum == 0)?v:lnum." '
            .. separator
            .. '":""}'

        vim.cmd("highlight LineNr0 guifg=#dedede")
        vim.cmd("highlight LineNr1 guifg=#bdbdbd")
        vim.cmd("highlight LineNr2 guifg=#9c9c9c")
        vim.cmd("highlight LineNr3 guifg=#7b7b7b")
        vim.cmd("highlight LineNr4 guifg=#5a5a5a")
    end,
})
