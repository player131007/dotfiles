return {
    {
        'williamboman/mason.nvim',
        build = "<cmd>MasonUpdate",
        config = function(_, opts)
            require('mason').setup(opts)
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        opts = {
            ensure_installed = {
                'clangd'
            }
        },
        config = function(_, opts)
            require('mason-lspconfig').setup(opts)
        end
    }
}
