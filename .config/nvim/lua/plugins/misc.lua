return {
    {
        'szw/vim-maximizer',
        cmd = 'MaximizerToggle',
        keys = {
            { "<leader>mx", "<cmd>MaximizerToggle<CR>" }
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
        build = ':TSUpdate',
        config = function(_, opts)
            require('nvim-treesitter').setup(opts)
            vim.cmd 'TSToggle highlight'
        end
    }
}
