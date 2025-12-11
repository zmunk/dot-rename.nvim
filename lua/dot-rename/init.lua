local M = {}

local default_opts = {
  mappings = {}
}

-- E.g: `opts = set_opts(opts, { only_current_line = false })`
local function set_opts(opts, defaults)
  return vim.tbl_extend("force", defaults, opts or {})
end

M.setup = function(opts)
  opts = set_opts(opts, default_opts)

  -- usage: ':RenameTo newValue'
  vim.api.nvim_create_user_command(
    'RenameTo',
    M.rename_selected_word,
    { nargs = '*', desc = 'Rename selected word' }
  )

  if opts.mappings.visual ~= nil then
    vim.keymap.set("v", opts.mappings.visual,
      "y:<C-u>RenameTo <C-r>\"<C-f>v0W",
      { desc = "Rename selected word", remap = false })
  end

  if opts.mappings.normal ~= nil then
    vim.keymap.set("n", opts.mappings.normal,
      "viwy:RenameTo <C-r>\"<C-f>v0W",
      { desc = "Rename word under cursor", remap = false })
  end
end

local replace_termcodes = function(keys)
  -- Converts special key notation like <Esc> into actual key codes
  --   true - from_part: treat as key sequence
  --   false - do_lt: don't interpret <lt>
  --   true - special: interpret special keys like <Esc>
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

local repeatable_replace = function(motion_type)
  if motion_type ~= "char" then
    vim.notify("Unhandled motion_type for this operator: " .. motion_type, vim.log.levels.ERROR)
    return
  end

  if vim.b.replacement_text == nil then
    vim.notify("vim.b.replacement_text not set", vim.log.levels.ERROR)
    return
  end

  local cmd = '`[v`]y' -- visually select and yank

  -- set '/' register to yanked text
  cmd = cmd ..
      ":<C-u>" ..
      "let @/='\\<" ..
      '<C-r>"' ..
      "\\>'<CR>"

  -- change current occurrence to replacement_text
  cmd = cmd .. "cgn" .. vim.b.replacement_text .. "<Esc>"

  vim.o.hls = true -- force re-highlight
  vim.cmd('normal! ' .. replace_termcodes(cmd))
end

_G.dot_rename = _G.dot_rename or {}
_G.dot_rename.repeatable_replace = repeatable_replace

M.rename_selected_word = function(opts)
  if opts.args == "" then
    vim.notify("Please provide 2 arguments.", vim.log.levels.ERROR)
    return
  end
  vim.b.replacement_text = opts.args

  -- this allows us to repeat the action using '.'
  vim.go.operatorfunc = "v:lua.dot_rename.repeatable_replace"
  vim.api.nvim_feedkeys(replace_termcodes("gvg@"), "x", false)

  vim.schedule(function()
    vim.notify("Press 'n' to go to next occurrence and '.' to repeat rename action.", vim.log.levels.INFO)
  end)
end

return M
