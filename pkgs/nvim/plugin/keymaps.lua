vim.keymap.set(
  "n",
  "grd",
  function() vim.lsp.buf.definition() end,
  { desc = "vim.lsp.buf.definition()" }
)

vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true })

vim.keymap.set("n", "U", "<cmd>redo<CR>")

vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-n>", true, false, true),
      "n",
      false
    )
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  ---@cast row -nil
  ---@cast col -nil
  if vim.fn.getline(row):sub(1, col):match("%S") then
    row = row - 1
    local ok, node = pcall(
      require("idk.treesitter").get_node,
      0,
      { row, col, row, col },
      function(node)
        local nrow, ncol = node:end_()
        return nrow == row and ncol == col
      end
    )
    if not ok or not node then goto fallback end
    ---@cast node TSNode

    local row, col = node:end_()
    row = row + 1
    if row > vim.api.nvim_buf_line_count(0) then -- node is the entire file, move to end of file
      row = vim.api.nvim_buf_line_count(0)
      col = vim.fn.col { row, "$" }
    end

    vim.api.nvim_win_set_cursor(0, { row, col })
    return
  end

  ::fallback::
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
    "n",
    false
  )
end)

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() ~= 0 then return "<C-p>" end
  return "<Tab>"
end, { expr = true })

local function set_jump_map(key, get_cursor)
  vim.keymap.set(
    { "n", "x" },
    key,
    function() require("idk.jump").jump(get_cursor()) end
  )
  vim.keymap.set(
    "o",
    key,
    function() return require("idk.jump").jump_expr(get_cursor()) end,
    { expr = true }
  )
end

for _, key in ipairs { "f", "F", "t", "T" } do
  set_jump_map(key, function()
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok or char == "\27" then return end

    return require("idk.jump").find(char, key:lower() == key, key:lower() == "t")
  end)
end

for _, key in ipairs { ";", "," } do
  set_jump_map(
    key,
    function() return require("idk.jump").repeat_find(key == ";") end
  )
end
