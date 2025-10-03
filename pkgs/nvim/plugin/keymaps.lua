vim.keymap.set({ "n", "v" }, "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set({ "n", "v" }, "N", "'nN'[v:searchforward]", { expr = true })

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
    local node = require("idk.util").get_parent_node(
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
