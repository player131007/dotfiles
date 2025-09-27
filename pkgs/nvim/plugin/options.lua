vim.g.mapleader = " "

vim.opt.cpoptions:remove("_")

vim.o.winborder = "rounded"

vim.o.shiftround = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a"

vim.o.showmode = false

vim.o.breakindent = true

vim.o.signcolumn = "yes"

vim.o.wrap = false

vim.o.cursorline = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = {
  trail = "·",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟨",
}

vim.o.scrolloff = 10

vim.o.confirm = true

vim.o.tabstop = 4

vim.o.expandtab = true
vim.o.softtabstop = 2
vim.o.shiftwidth = vim.o.softtabstop

vim.o.virtualedit = "block"

vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.wildoptions = "pum,fuzzy"

vim.o.pumheight = 15

vim.o.shortmess = "FOCaco"
