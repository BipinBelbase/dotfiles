-- Run from repo root with lua tests/test_debugging.lua, or:
-- nvim --headless -u NONE -c 'luafile tests/test_debugging.lua' -c qa
local specs = dofile('nvim/lua/plugins/debugging.lua')
local count = 0
for _, spec in ipairs(specs) do
    if spec.keys then
        local fn = function() end
        local keys = {
            { '<leader>db', fn, desc = 'Breakpoint' },
            { '<leader>dO', fn, desc = 'Step over' },
            { '<leader>dPt', fn, ft = 'python' },
            { '<leader>de', fn, mode = { 'n', 'x' } },
            { '<F5>', fn },
        }
        local result = spec.keys(nil, keys)
        assert(result[1][1] == '<leader>Db' and result[1][2] == fn)
        assert(result[1].desc == 'Breakpoint')
        assert(result[2][1] == '<leader>DO')
        assert(result[3][1] == '<leader>DPt' and result[3].ft == 'python')
        assert(result[4][1] == '<leader>De' and result[4].mode[2] == 'x')
        assert(result[5][1] == '<F5>')
        assert(spec.keys(nil, result)[1][1] == '<leader>Db')
        count = count + 1
    end
end
assert(count == 3, 'DAP, UI and Python mappings must all be remapped')
assert(specs[4].opts.spec[1][1] == '<leader>D')
print('PASS: debugger mappings preserve handlers, modes and unrelated keys')
