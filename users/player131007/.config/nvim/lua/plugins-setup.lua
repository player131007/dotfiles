local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'L3MON4D3/LuaSnip',
        version = '*',
        config = function(_, opts)
            require('luasnip').config.set_config { update_events = 'TextChanged,TextChangedI' }
            require('luasnip.loaders.from_lua').lazy_load { paths = '~/.config/nvim/lua/snippets/' }
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        opts = function()
            return require 'plugins-config.cmp'
        end,
        config = function(_, opts)
            require('cmp').setup(opts)
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help'
        }
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        opts = require('plugins-config.misc').rose_pine,
        config = function(_, opts)
            require('rose-pine').setup(opts)
            vim.cmd.colorscheme('rose-pine')
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'rose-pine' },
        event = 'ColorScheme',
        opts = require('plugins-config.misc').lualine
    },
    {
        'szw/vim-maximizer',
        keys = {
            { '<leader>mx', '<cmd>MaximizerToggle<CR>' }
        }
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter').setup()
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.hypr = {
                install_info = {
                    url = "https://github.com/luckasRanarison/tree-sitter-hypr",
                    files = { "src/parser.c" },
                    branch = "master",
                },
                filetype = "hypr",
            }
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'cpp', 'lua', 'nix', 'hypr', 'javascript' },
                highlight = {
                    enable = true
                }
            }
        end
    },
    {
        'luckasRanarison/tree-sitter-hypr',
        dependencies = {
            'nvim-treesitter'
        }
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require('lsp_lines').setup {}
            vim.diagnostic.config { virtual_text = false }
        end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require 'lspconfig'
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.nil_ls.setup {}
            lspconfig.clangd.setup {
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "-j",
                    "4",
                    "--malloc-trim",
                    "--pch-storage=memory",
                    "--header-insertion=never"
                }
            }
        end
    },
    {
        'is0n/jaq-nvim',
        opts = require('plugins-config.misc').jaq,
        cmd = "Jaq",
        keys = { { '<F9>', '<cmd>Jaq<CR>'} }
    },
    {
        'ellisonleao/carbon-now.nvim',
        cmd = 'CarbonNow',
        opts = require('plugins-config.misc').carbon_now
    },
})
