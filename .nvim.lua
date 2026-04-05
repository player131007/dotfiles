vim.opt.runtimepath:append(vim.fn.fnamemodify(".nvim", ":p"))
vim.cmd("set path+=modules/**,pkgs,pkgs/by-name/**,hosts/**")
vim.o.exrc = false
