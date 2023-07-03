local M = {}

M.lsps = {
    ensure_installed = {
        'clangd',
        'nil_ls'
    }
}

M.rose_pine = {
    disable_italics = true
}

M.lualine = {
    options = {
        theme = 'rose-pine'
    }
}

return M
