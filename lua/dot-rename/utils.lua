local M = {}

-- E.g: `opts = set_opts(opts, { only_current_line = false })`
M.set_opts = function(opts, defaults)
  return vim.tbl_extend("force", defaults, opts or {})
end

return M
