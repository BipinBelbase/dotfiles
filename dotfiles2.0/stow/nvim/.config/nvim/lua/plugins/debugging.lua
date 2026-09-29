-- Keep the existing <leader>d black-hole delete mapping.
-- LazyVim's language extras supply the Python and C/C++ adapters.
local function debug_keys(_, keys)
    for _, key in ipairs(keys) do
        if type(key[1]) == "string" then
            key[1] = key[1]:gsub("^<leader>d", "<leader>D")
        end
    end
    return keys
end

return {
    { "mfussenegger/nvim-dap", keys = debug_keys },
    { "rcarriga/nvim-dap-ui", keys = debug_keys },
    { "mfussenegger/nvim-dap-python", keys = debug_keys },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>D", group = "debug", mode = { "n", "v" } },
            },
        },
    },
}
