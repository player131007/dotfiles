require("rose-pine").setup {
  dim_inactive_windows = true,

  highlight_groups = {
    MiniStatuslineFilename = { fg = "text" },
  },

  styles = {
    bold = true,
    italic = true,
    transparency = false,
  },
}

vim.cmd("colorscheme rose-pine-main")
