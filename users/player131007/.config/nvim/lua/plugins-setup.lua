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
        config = require('plugins-config.misc').luasnip
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        config = require 'plugins-config.cmp',
        dependencies = {
            'windwp/nvim-autopairs',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help'
        }
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        config = require('plugins-config.misc').rose_pine
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'rose-pine' },
        event = 'ColorScheme',
        config = require('plugins-config.misc').lualine
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
        config = require('plugins-config.treesitter')
    },
    {
        'luckasRanarison/tree-sitter-hypr',
        lazy = false
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = require('plugins-config.misc').lsp_lines
    },
    {
        'neovim/nvim-lspconfig',
        config = require('plugins-config.lspconfig')
    },
    {
        'is0n/jaq-nvim',
        config = require('plugins-config.misc').jaq,
        cmd = "Jaq",
        keys = { { '<F9>', '<cmd>Jaq<CR>'} }
    },
    {
        'ellisonleao/carbon-now.nvim',
        cmd = 'CarbonNow',
        config = require('plugins-config.misc').carbon_now
    },
})
