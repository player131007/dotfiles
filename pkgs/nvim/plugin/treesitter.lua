vim.g.loaded_nvim_treesitter = true

vim.opt.runtimepath:append(
  require("nvim-treesitter.install").get_package_path("runtime")
)
