local augroup = vim.api.nvim_create_augroup("UserAugroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Automatically enable treesitter if available",
  callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Make files in /nix/store unmodifiable",
  pattern = "/nix/store/*",
  callback = function(args) vim.bo[args.buf].modifiable = false end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight when yanking (copying) text",
  callback = function() vim.hl.on_yank() end,
})
