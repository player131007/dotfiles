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
    ---@cast node -nil

    ---@param root TSNode
    ---@return TSNode?
    local function find(root)
      local child = root:child_with_descendant(node)
      if child then
        local node = find(child)
        if node then return node end
      end

      ---@diagnostic disable-next-line: unnecessary-if
      if not should_skip(root) then return root end
    end

    local node = find(root)
    if node then return node end

    lt = lt:parent() ---@as vim.treesitter.LanguageTree
  end
end

return M
