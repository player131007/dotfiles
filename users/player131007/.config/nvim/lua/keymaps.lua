vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>nh", "<cmd>nohl<CR>")

keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", "<cmd>close<CR>")

keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

keymap.set('n', '[d', vim.diagnostic.goto_prev)
keymap.set('n', ']d', vim.diagnostic.goto_next)
keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, opts)
    keymap.set('n', '<leader>gD', vim.lsp.buf.definition, opts)
    keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
    keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    keymap.set('n', '<leader>tD', vim.lsp.buf.type_definition, opts)
    keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
  end,
})
