local utils = require('dot-rename.utils')

local M = {}

local default_opts = {
  mappings = {}
}

local repeatable_replace = function(motion_type)
  if motion_type ~= "char" then
    vim.notify("Unhandled motion_type for this operator: " .. motion_type, vim.log.levels.ERROR)
    return
  end

  if vim.b.replacement_text == nil then
    vim.notify("vim.b.replacement_text not set", vim.log.levels.ERROR)
    return
  end

  if vim.b.text_to_rename == nil then
    vim.notify("no text selected", vim.log.levels.ERROR)
    return
  end

  -- set '/' register to yanked text
  local cmd = ":<C-u>" ..
      "let @/='\\<" .. vim.b.text_to_rename .. "\\>'<CR>"

  -- change current occurrence to replacement_text
  cmd = cmd .. "cgn" .. vim.b.replacement_text .. "<Esc>"

  vim.o.hls = true -- force re-highlight
  vim.cmd('normal! ' .. utils.replace_termcodes(cmd))
end


M.setup = function(opts)
  opts = utils.set_opts(opts, default_opts)

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

  if opts.mappings.resume ~= nil then
    vim.keymap.set("n", opts.mappings.resume, function()
        if vim.b.text_to_rename == nil or vim.b.replacement_text == nil then
          return
        end
        repeatable_replace("char")
      end,
      { desc = "Resume last rename operation", remap = false })
  end
end

_G.dot_rename = _G.dot_rename or {}
_G.dot_rename.repeatable_replace = repeatable_replace

M.rename_selected_word = function(opts)
  if opts.args == "" then
    vim.notify("Please provide 2 arguments.", vim.log.levels.ERROR)
    return
  end
  vim.b.replacement_text = opts.args

  vim.b.text_to_rename = utils.get_selection()

  -- this allows us to repeat the action using '.'
  vim.go.operatorfunc = "v:lua.dot_rename.repeatable_replace"
  vim.api.nvim_feedkeys("gvg@", "x", false)

  vim.schedule(function()
    vim.notify("Press 'n' to go to next occurrence and '.' to repeat rename action.", vim.log.levels.INFO)
  end)
end

return M
