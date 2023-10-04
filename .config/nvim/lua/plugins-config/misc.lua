local M = {}

M.rose_pine = {
    disable_italics = true,
    highlight_groups = {
        Whitespace = { fg = 'highlight_med' }
    }
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

M.carbon_now = {
    options = {
        theme = "one-dark",
        font_family = "Fira Code",
        font_size = "14px"
    },
}

return M
