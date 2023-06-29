return {
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
    }
}
