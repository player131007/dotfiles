vim.opt.runtimepath:append(vim.fn.fnamemodify(".nvim", ":p"))
vim.cmd("set path+=plugin/**,lua/**,ftplugin,ftplugin/*")
vim.o.exrc = false
