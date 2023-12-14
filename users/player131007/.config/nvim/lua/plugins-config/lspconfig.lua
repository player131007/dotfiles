return function()
    local lspconfig = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    lspconfig.nil_ls.setup {
        capabilities = capabilities
    }
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
