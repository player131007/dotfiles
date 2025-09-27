vim.keymap.set({ "n", "v" }, "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set({ "n", "v" }, "N", "'nN'[v:searchforward]", { expr = true })

vim.keymap.set("n", "U", "<cmd>redo<CR>")

local function get_parent_node(should_skip)
  if not should_skip then should_skip = function() return false end end

  local node = vim.treesitter.get_node { ignore_injections = false }
  if not node then
    vim.notify("No treesitter node under cursor", vim.log.levels.ERROR)
    return nil
  end

  while node and should_skip(node) do
    node = node:parent()
  end

  return node
end

local function press(keys)
  --- @diagnostic disable-next-line: redefined-local
  local keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

local function move_parent_node_end()
  local parent = get_parent_node()
  if not parent then return false end

  local row, col = parent:end_()
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
  return true
end

local function move_parent_node_start()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local parent = get_parent_node(function(node)
    local node_row, node_col = node:start()
    local comp = {
      __lt = function(a, b) return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2]) end,
    }
    local node_pos = setmetatable({ node_row, node_col }, comp)
    --- @diagnostic disable-next-line: need-check-nil
    local cursor_pos = setmetatable({ row - 1, col }, comp)

    return node_pos >= cursor_pos or not node:named()
  end)

  if not parent then return false end

  --- @diagnostic disable-next-line: redefined-local
  local row, col = parent:start()
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
  return true
end

vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    press("<C-n>")
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  --- @diagnostic disable-next-line
  if
    vim.api.nvim_buf_get_text(0, row - 1, 0, row - 1, col, {})[1]:match("%S")
    and move_parent_node_end()
  then
    return
  end

  press("<Tab>")
end)

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    press("<C-p>")
    return
  end

  if move_parent_node_start() then return end

  press("<S-Tab>")
end)
