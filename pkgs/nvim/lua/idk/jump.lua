local M = {}

---@param char string
---@param forward boolean
---@param till boolean
---@return string pattern
---@return string hl_pattern
---@return string flags
function M.make_search_params(char, forward, till)
  vim.validate("char", char, "string")
  vim.validate("forward", forward, "boolean")
  vim.validate("till", till, "boolean")

  local pattern = vim.fn.escape(char, "\\")
  local flags = forward and "W" or "Wb"
  local suffix = ""

  if till then
    if forward then
      pattern = [[\_.]] .. pattern .. [[\@=]]
    else
      pattern = pattern .. [[\@<=]]
    end
  else
    local is_visual = vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode())
    local is_exclusive = vim.o.selection == "exclusive"

    if forward and is_visual and is_exclusive then
      -- select past the target in case of exclusive selection
      suffix = suffix .. [[\@<=]]
    end
  end

  local ignorecase = vim.o.ignorecase
    and (not vim.o.smartcase or char == char:lower())
  pattern = (ignorecase and [[\c]] or "") .. [[\V]] .. pattern

  return pattern .. suffix, pattern, flags
end

---@class HighlightState
---@field stop fun()
---@field timer any
local highlight = {}

---@param char string
---@param forward boolean
---@param till boolean
---@return integer[]?
function M.find(char, forward, till)
  local pattern, hl_pattern, flags = M.make_search_params(char, forward, till)
  local orig, cursor = vim.api.nvim_win_get_cursor(0), nil

  for _ = 1, vim.v.count1 do
    if vim.fn.search(pattern, flags) == 0 then
      vim.api.nvim_win_set_cursor(0, orig)
      return
    end
  end

  if highlight.timer and highlight.timer:is_active() then
    highlight.timer:close(vim.schedule_wrap(highlight.stop))
  end

  local winid = vim.api.nvim_get_current_win()
  local hl = vim.fn.matchadd("Search", hl_pattern)
  highlight.stop = function() vim.fn.matchdelete(hl, winid) end
  highlight.timer = vim.defer_fn(highlight.stop, 1000)

  cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, orig)
  return cursor
end

return M
