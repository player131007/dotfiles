local augroup = vim.api.nvim_create_augroup("UserAugroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Automatically enable treesitter if available",
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight when yanking (copying) text",
  callback = function() vim.hl.on_yank() end,
})
