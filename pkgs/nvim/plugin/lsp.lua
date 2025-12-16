-- semantic tokens override treesitter injections
vim.api.nvim_set_hl(0, "@lsp.type.string.lua", {})

vim.lsp.enable { "emmylua_ls", "nixd" }
