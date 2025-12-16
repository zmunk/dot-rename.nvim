local M = {}

M.replace_termcodes = function(keys)
  -- Converts special key notation like <Esc> into actual key codes
  --   true - from_part: treat as key sequence
  --   false - do_lt: don't interpret <lt>
  --   true - special: interpret special keys like <Esc>
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

-- E.g: `opts = set_opts(opts, { only_current_line = false })`
M.set_opts = function(opts, defaults)
  return vim.tbl_extend("force", defaults, opts or {})
end

M.get_selection = function()
  -- Get start and end positions (1-indexed)
  local start = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local row = start[2] - 1

  if end_pos[2] - 1 ~= row then
    -- multi-line selection not allowed
    return nil
  end

  local start_col = start[3] - 1
  local end_col = end_pos[3] -- End col is inclusive, so no -1

  return vim.api.nvim_buf_get_text(0, row, start_col, row, end_col, {})[1]
end

return M
