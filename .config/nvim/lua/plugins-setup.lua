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
        version = '*'
    },
    {
        'hrsh7th/nvim-cmp',
        opts = function()
            return require 'plugins-config.cmp'
        end,
        dependencies = {
            'L3MON4D3/LuaSnip',
            {
                'saadparwaiz1/cmp_luasnip',
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-nvim-lsp-signature-help'
            }
        }
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        opts = require('plugins-config.misc').rose_pine,
        config = function(_, opts)
            require('rose-pine').setup(opts)
            vim.cmd('colorscheme rose-pine')
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'rose-pine' },
        opts = require('plugins-config.misc').lualine
    },
    {
        'szw/vim-maximizer',
        cmd = "MaximizerToggle",
        keys = {
            { '<leader>mx', '<cmd>MaximizerToggle<CR>' }
        }
    },
    {
        'tpope/vim-surround',
        keys = { 'cs', 'cst', 'ds', 'ys', 'yss' }
    },
    {
        'tpope/vim-commentary',
        keys = { 'gc', 'gcc' }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter').setup()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'cpp', 'lua', 'nix' },
                highlight = {
                    enable = true
                }
            }
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make'
            }
        },
        cmd = 'Telescope',
        keys = {
            { '<leader>ff', '<cmd>Telescope find_files<CR>' },
            { '<leader>fs', '<cmd>Telescope live_grep<CR>' },
            { '<leader>fb', '<cmd>Telescope buffers<CR>' },
            { '<leader>fh', '<cmd>Telescope help_tags<CR>' }
        },
        config = function(_, opts)
            require('telescope').setup(opts)
            require('telescope').load_extension('fzf')
        end
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        config = function()
            local lspconfig = require 'lspconfig'
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.clangd.setup {
                capabilities = capabilities
            }
        end
    }
})
