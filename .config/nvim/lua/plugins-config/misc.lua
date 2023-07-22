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

M.jaq = {
    cmds = {
        external = {
            cpp = "clang++ -I/d/dead -std=c++14 -DLOCAL -w -g -D_GLIBCXX_DEBUG -fsanitize=address,undefined -fno-sanitize-recover=all % && ./a.out"
        }
    },
    behavior = {
        autosave = true,
        startinsert = false
    }
}

return M
