local M = {}

--- @param bufnr integer
--- @param range Range4
--- @param should_skip? fun(node: TSNode): boolean
--- @return TSNode?
function M.get_parent_node(bufnr, range, should_skip)
  bufnr = bufnr ~= 0 and bufnr or vim.api.nvim_win_get_buf(0)
  local root_ltree = assert(vim.treesitter.get_parser(bufnr))
  root_ltree:parse()

  --- @param ltree vim.treesitter.LanguageTree
  --- @return TSNode?
  local function search(ltree)
    if not ltree:contains(range) then return nil end

    for _, child in pairs(ltree:children()) do
      local node = search(child)
      if node then return node end
    end

    local node = ltree:named_node_for_range(range)
    while node and should_skip and should_skip(node) do
      node = node:parent()
    end
    return node
  end

  return search(root_ltree)
end

return M
