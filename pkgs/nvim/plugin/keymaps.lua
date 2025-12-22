vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true })

vim.keymap.set("n", "U", "<cmd>redo<CR>")

local function press(keys)
  --- @diagnostic disable-next-line: redefined-local
  local keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    press("<C-n>")
    return
  end

  --- @diagnostic disable-next-line: assign-type-mismatch
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) ---@type integer, integer
  row = row - 1

  local text = vim.api.nvim_buf_get_text(0, row, 0, row, col, {})[1] --- @as string
  if text:match("%S") then
    local node = require("idk.treesitter").get_parent_node(
      0,
      { row, col, row, col },
      function(n)
        local nrow, ncol = n:end_()
        return row == nrow and col == ncol
      end
    )
    if not node then
      vim.notify("No treesitter node found", vim.log.levels.INFO)
      return
    end

    --- @diagnostic disable-next-line: redefined-local
    local row, col = node:end_()
    local ok, err = pcall(vim.api.nvim_win_set_cursor, 0, { row + 1, col })
    if not ok then
      vim.notify(
        string.format("%s (%d, %d)", err, row + 1, col + 1),
        vim.log.levels.ERROR
      )
    end

    return
  end

  press("<Tab>")
end)

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    press("<C-p>")
    return
  end

  --- @diagnostic disable-next-line: assign-type-mismatch
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) ---@type integer, integer
  row = row - 1

  local node = require("idk.util").get_parent_node(
    0,
    { row, col, row, col },
    function(n)
      local nrow, ncol = n:start()
      return row == nrow and col == ncol
    end
  )
  if not node then
    vim.notify("No treesitter node found", vim.log.levels.INFO)
    return
  end

  --- @diagnostic disable-next-line: redefined-local
  local row, col = node:start()
  local ok, err = pcall(vim.api.nvim_win_set_cursor, 0, { row + 1, col })
  if not ok then
    vim.notify(
      string.format("%s (%d, %d)", err, row + 1, col + 1),
      vim.log.levels.ERROR
    )
  end
end)

local function jump(cursor)
  if not cursor then return end
  vim.api.nvim_win_set_cursor(0, cursor)
end

local function jump_operator(cursor)
  if not cursor then return "<Esc>" end

  return ("v<Cmd>lua vim.api.nvim_win_set_cursor(0, %s)<CR>"):format(
    vim.inspect(cursor)
  )
end

---@class LastJumpState
---@field char string
---@field till boolean
local last_jump = {}
for _, key in pairs { "f", "F", "t", "T" } do
  local function get_cursor()
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok or char == "\27" then return end

    local till = key:lower() == "t"
    last_jump = {
      char = char,
      till = till,
    }
    return require("idk.jump").find(char, key:lower() == key, till)
  end

  vim.keymap.set({ "n", "x" }, key, function() jump(get_cursor()) end)
  vim.keymap.set(
    "o",
    key,
    function() return jump_operator(get_cursor()) end,
    { expr = true }
  )
end

for _, key in pairs { ";", "," } do
  local function get_cursor()
    if not last_jump.char then return end
    return require("idk.jump").find(last_jump.char, key == ";", last_jump.till)
  end

  vim.keymap.set({ "n", "x" }, key, function() jump(get_cursor()) end)
  vim.keymap.set(
    "o",
    key,
    function() return jump_operator(get_cursor()) end,
    { expr = true }
  )
end
