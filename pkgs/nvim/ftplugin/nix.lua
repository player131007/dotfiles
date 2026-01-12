if vim.b.loaded_nix_ftplugin then return end
vim.b.loaded_nix_ftplugin = true

vim.keymap.set("i", "<C-x><C-f>", function()
  vim.cmd.lcd(vim.fn.expand("%:p:h"))
  vim.api.nvim_create_autocmd("CompleteChanged", {
    buffer = 0,
    once = true,
    command = "lcd -",
  })
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<C-x><C-f>", true, false, true),
    "n",
    false
  )
end, { buffer = true })
