return {
    luasnip = function()
        require('luasnip').config.set_config {
            update_events = 'TextChanged,TextChangedI'
        }
        require('luasnip.loaders.from_lua').lazy_load {
            paths = "~/.config/nvim/lua/snippets"
        }
    end,
    rose_pine = function()
        require('rose-pine').setup {
            disable_italics = true,
            highlight_groups = {
                Whitespace = { fg = 'highlight_med' }
            }
        }
        vim.cmd.colorscheme('rose-pine')
    end,
    lualine = function()
        require('lualine').setup {
            options = {
                theme = 'rose-pine'
            }
        }
    end,
    lsp_lines = function()
        require('lsp_lines').setup {}
        vim.diagnostic.config { virtual_text = false }
    end,
    jaq = function()
        require('jaq-nvim').setup {
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
    end,
    carbon_now = function()
        require('carbon-now').setup {
            options = {
                theme = "one-dark",
                font_family = "Fira Code",
                font_size = "14px"
            }
        }
    end
}
