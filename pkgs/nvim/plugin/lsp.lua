vim.api.nvim_create_user_command(
  "LspLog",
  function() vim.cmd.tabedit(vim.lsp.log.get_filename()) end,
  {
    desc = "Open lsp log file",
  }
)

vim.lsp.enable { "emmylua_ls", "nixd" }

-- so treesitter injections can work
vim.api.nvim_set_hl(0, "@lsp.type.string.lua", {})
