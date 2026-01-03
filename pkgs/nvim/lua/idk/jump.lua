local M = {}

---@param char string
---@param forward boolean
---@param till boolean
---@return string pattern
---@return string hl_pattern
---@return string flags
local function make_search_params(char, forward, till)
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
local hl = {
  timer = vim.uv.new_timer(),
}

---@class LastJumpState
---@field char string
---@field till boolean
local last_jump = nil

---@param char string
---@param forward boolean
---@param till boolean
---@return integer[]?
function M.find(char, forward, till)
  vim.validate("char", char, "string")
  vim.validate("forward", forward, "boolean")
  vim.validate("till", till, "boolean")

  local pattern, hl_pattern, flags = make_search_params(char, forward, till)
  local orig, cursor = vim.api.nvim_win_get_cursor(0), nil

  last_jump = {
    char = char,
    till = till,
  }

  for _ = 1, vim.v.count1 do
    if vim.fn.search(pattern, flags) == 0 then
      vim.api.nvim_win_set_cursor(0, orig)
      return
    end
  end

  if hl.timer:is_active() then
    hl.timer:stop()
    hl.stop()
  end

  local winid = vim.api.nvim_get_current_win()
  local hl_id = vim.fn.matchadd("Search", hl_pattern)
  hl.stop = vim.schedule_wrap(function() vim.fn.matchdelete(hl_id, winid) end)
  hl.timer:start(1000, 0, hl.stop)

  cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, orig)
  return cursor
end

function M.repeat_find(forward)
  if not last_jump then return end
  return M.find(last_jump.char, forward, last_jump.till)
end

function M.jump(cursor)
  if not cursor then return end
  vim.api.nvim_win_set_cursor(0, cursor)
  vim.cmd("normal! zv")
end

function M.jump_expr(cursor)
  if not cursor then return "<Esc>" end
  M.cursor = cursor
  return "v<Cmd>lua local x = require('idk.jump'); x.jump(x.cursor)<CR>"
end

return M
