local modes = { "n", "v", "x", "i", "t", "c", "o", "s" }

local user_key_index = {
  ["n|n"] = true,
  ["n|N"] = true,
  ["n|J"] = true,
  ["n|<C-D>"] = true,
  ["n|<C-U>"] = true,
  ["n|<C-F>"] = true,
  ["n|<C-Up>"] = true,
  ["n|<C-Down>"] = true,
  ["n|<C-Left>"] = true,
  ["n|<C-Right>"] = true,
  ["n|<C-d>"] = true,
  ["n|<C-u>"] = true,
  ["n|<C-f>"] = true,
  ["v|J"] = true,
  ["v|K"] = true,
  ["n|<leader>d"] = true,
  ["v|<leader>d"] = true,
  ["x|<leader>d"] = true,
  ["n|<leader>y"] = true,
  ["v|<leader>y"] = true,
  ["s|<leader>y"] = true,
  ["x|<leader>y"] = true,
  ["n|<leader>Y"] = true,
  ["x|<leader>p"] = true,
  ["n|<leader>fr"] = true,
  ["n|Q"] = true,
  ["n|<leader>e"] = true,
  ["n|<leader>fx"] = true,
}

local function normalize_lhs(lhs)
  if lhs:sub(1, 1) == " " then
    return "<leader>" .. lhs:sub(2)
  end
  return lhs
end

local function trim(text)
  return (text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " "))
end

local function escape_cell(text)
  return text:gsub("|", "\\|")
end

local function mode_label(mode)
  if mode == "n" then
    return "n"
  end
  if mode == "v" then
    return "v"
  end
  if mode == "x" then
    return "x"
  end
  if mode == "i" then
    return "i"
  end
  if mode == "t" then
    return "t"
  end
  if mode == "c" then
    return "c"
  end
  if mode == "o" then
    return "o"
  end
  if mode == "s" then
    return "s"
  end
  return mode
end

local function key_category(lhs, action, plugin)
  local desc = action:lower()

  if lhs:match("^<leader>[1-5]$") or lhs:match("^<leader>h") or desc:find("harpoon", 1, true) then
    return "Harpoon"
  end

  if lhs:match("^<leader>f")
    or lhs == "<leader>e"
    or desc:find("find", 1, true)
    or desc:find("search", 1, true)
    or desc:find("explorer", 1, true)
    or desc:find("replace", 1, true)
  then
    return "Find and Navigation"
  end

  if lhs:match("^<leader>g") or desc:find("git", 1, true) then
    return "Git"
  end

  if lhs:match("^<leader>x")
    or lhs:match("^%[q$")
    or lhs:match("^%]q$")
    or desc:find("diagnostic", 1, true)
    or desc:find("trouble", 1, true)
    or desc:find("quickfix", 1, true)
  then
    return "Diagnostics and Lists"
  end

  if lhs:match("^<leader>c")
    or lhs:match("^<leader>r")
    or desc:find("code", 1, true)
    or desc:find("format", 1, true)
    or desc:find("refactor", 1, true)
    or desc:find("rename", 1, true)
    or plugin:find("lsp")
  then
    return "Code and LSP"
  end

  if lhs:match("^<leader>u") or desc:find("toggle", 1, true) then
    return "UI and Toggles"
  end

  if lhs:match("^<leader>t") or desc:find("terminal", 1, true) then
    return "Terminal"
  end

  return "Editing and Misc"
end

local function plugin_name(lhs, mode, handlers, keys_handler)
  local key = mode .. "|" .. lhs
  if user_key_index[key] then
    return "User config"
  end

  local ok, parsed = pcall(keys_handler.parse, { lhs, mode = mode })
  if ok and parsed and parsed.id then
    local owners = handlers[parsed.id]
    if type(owners) == "table" and next(owners) ~= nil then
      local names = {}
      for name, _ in pairs(owners) do
        table.insert(names, name)
      end
      table.sort(names)
      return table.concat(names, ", ")
    end
  end

  return "LazyVim core"
end

local function collect_maps()
  local handler = require("lazy.core.handler")
  local keys_handler = require("lazy.core.handler.keys")
  local handlers = (handler.handlers and handler.handlers.keys and handler.handlers.keys.active) or {}
  local seen = {}
  local entries = {}

  for _, mode in ipairs(modes) do
    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
      local lhs = map.lhs or ""
      lhs = normalize_lhs(lhs)
      if lhs ~= "" and not lhs:match("^<Plug>") then
        local uniq = mode .. "|" .. lhs
        local action = map.desc

        if action == nil or action == "" then
          if map.rhs and map.rhs ~= "" then
            action = map.rhs
          else
            action = "(Lua callback)"
          end
        end

        action = trim(action)
        local plugin = plugin_name(lhs, mode, handlers, keys_handler)
        local category = key_category(lhs, action, plugin)

        if not seen[uniq] then
          seen[uniq] = #entries + 1
          table.insert(entries, {
            lhs = lhs,
            mode = mode,
            action = action,
            plugin = plugin,
            category = category,
          })
        else
          local idx = seen[uniq]
          if entries[idx].action == "(Lua callback)" and map.desc and map.desc ~= "" then
            entries[idx].action = trim(map.desc)
          end
        end
      end
    end
  end

  table.sort(entries, function(a, b)
    if a.category ~= b.category then
      return a.category < b.category
    end
    if a.mode ~= b.mode then
      return a.mode < b.mode
    end
    return a.lhs < b.lhs
  end)

  return entries
end

local function to_markdown(entries)
  local lines = {
    "# Keymaps",
    "",
    "Generated from the live Neovim config on startup (`nvim --headless`) so it stays in sync with LazyVim defaults and local overrides.",
    "",
    "- Leader key: `<Space>`",
    "- Generated at: `" .. os.date("!%Y-%m-%d %H:%M:%SZ") .. "`",
    "- Total keymaps: `" .. tostring(#entries) .. "`",
    "",
  }

  local current = nil
  for _, entry in ipairs(entries) do
    if current ~= entry.category then
      if current ~= nil then
        table.insert(lines, "")
      end
      current = entry.category
      table.insert(lines, "## " .. current)
      table.insert(lines, "")
      table.insert(lines, "| Key | Mode | Action | Plugin |")
      table.insert(lines, "| --- | --- | --- | --- |")
    end

    table.insert(
      lines,
      string.format(
        "| `%s` | `%s` | %s | `%s` |",
        escape_cell(entry.lhs),
        mode_label(entry.mode),
        escape_cell(entry.action),
        escape_cell(entry.plugin)
      )
    )
  end

  return lines
end

local function write_docs()
  pcall(vim.api.nvim_exec_autocmds, "User", { pattern = "VeryLazy" })

  local entries = collect_maps()
  local markdown_lines = to_markdown(entries)
  vim.fn.mkdir("docs", "p")
  vim.fn.writefile(markdown_lines, "docs/keymaps.md")

  print(string.format("Generated docs/keymaps.md with %d keymaps", #entries))
end

write_docs()
