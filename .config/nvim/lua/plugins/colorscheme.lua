return {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        opts = {
            disable_italics = true
        },
        config = function(_, opts)
            require('rose-pine').setup(opts)  
            vim.cmd('colorscheme rose-pine')
        end
    }
}
