local cmp = require 'cmp'
local luasnip = require 'luasnip'

local options = {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },

    sources = cmp.config.sources {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' }
    },

    mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback()
            end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping {
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                else fallback()
                end
            end,
            s = cmp.mapping.confirm { select = true }
        }
    }
}

return options
