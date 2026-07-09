local utils = require('dot-rename.utils')

local M = {}

local default_opts = {
  mappings = {}
}

local rename_pattern = function(opts)
  local arg = opts.args
  local delim = arg:sub(1, 1)

  if delim == "" or delim:match("%s") then
    vim.notify("Usage: :rename/from/to", vim.log.levels.ERROR)
    return
  end

  local parts = { "", "" }
  local part = 1
  local i = 2

  while i <= #arg and part <= 2 do
    local ch = arg:sub(i, i)
    local next_ch = arg:sub(i + 1, i + 1)

    if ch == "\\" and next_ch == delim then
      parts[part] = parts[part] .. delim
      i = i + 2
    elseif ch == "\\" and next_ch ~= "" then
      parts[part] = parts[part] .. "\\" .. next_ch
      i = i + 2
    elseif ch == delim then
      part = part + 1
      i = i + 1
    else
      parts[part] = parts[part] .. ch
      i = i + 1
    end
  end
  local pattern = parts[1]
  local replacement = parts[2]

  if vim.fn.search(pattern, "nw") == 0 then
    vim.notify("Pattern not found: " .. pattern, vim.log.levels.ERROR)
    return
  end

  vim.fn.setreg("/", pattern, "c")
  vim.o.hlsearch = true
  vim.v.hlsearch = 1

  vim.cmd("norm! cgn" .. replacement)

  vim.schedule(function()
    vim.notify("Press 'n' to go to next occurrence and '.' to repeat rename action.", vim.log.levels.INFO)
  end)

end

M.setup = function(opts)
  opts = utils.set_opts(opts, default_opts)

  -- Usage:
  -- - ':RenamePattern /from/to'
  -- - ':rename /from/to'
  -- - ':rename/from/to'

  vim.api.nvim_create_user_command("RenamePattern", rename_pattern, { nargs = 1 })
  vim.cmd.cnoreabbrev({ "rename", "RenamePattern" })

  if opts.mappings.visual ~= nil then
    vim.keymap.set("v", opts.mappings.visual,
      "y:<C-u>RenamePattern/<C-r>\"/<C-r>\"<C-f>vT/",
      { desc = "Rename selection", remap = false })
  end

  if opts.mappings.normal ~= nil then
    vim.keymap.set("n", opts.mappings.normal,
      "yiw:RenamePattern/\\<<C-r>\"\\>/<C-r>\"<C-f>vT/",
      { desc = "Rename word under cursor", remap = false })
  end

end
--
return M
