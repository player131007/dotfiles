local M = {}

---@param bufnr integer
---@param range Range4
---@param should_skip? fun(TSNode): boolean
---@return TSNode?
function M.get_node(bufnr, range, should_skip)
  should_skip = should_skip or function(_) return false end

  local root = assert(vim.treesitter.get_parser(bufnr, nil, { error = false }))

  local lt = root:language_for_range(range)
  while lt do
    local root = assert(lt:tree_for_range(range)):root()
    local node = root:descendant_for_range(unpack(range))

    while node and should_skip(node) do
      node = root:child_with_descendant(node)
    end
    if node then return node end

    lt = lt:parent() ---@as vim.treesitter.LanguageTree
  end
end

return M
