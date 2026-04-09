if vim.g.loaded_typst_ftplugin then return end
vim.g.loaded_typst_ftplugin = true

require("typst-preview").setup {
  open_cmd = "qutebrowser --loglevel critical --temp-basedir --untrusted-args %s",
  dependencies_bin = {
    tinymist = "tinymist",
    websocat = "websocat",
  },
}
