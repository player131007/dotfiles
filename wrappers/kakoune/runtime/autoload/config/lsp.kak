evaluate-commands %sh{kak-lsp}
lsp-enable

map global user l ':enter-user-mode lsp<ret>' -docstring 'LSP mode'

map global goto d <esc>:lsp-definition<ret> -docstring 'LSP definition'
map global goto r <esc>:lsp-references<ret> -docstring 'LSP references'
map global goto y <esc>:lsp-type-definition<ret> -docstring 'LSP type definition'

remove-hooks global lsp-filetype-nix
hook -group lsp-filetype-nix global BufSetOption filetype=nix %{
    set-option buffer lsp_servers %{
        [nixd]
        root_globs = ["flake.nix", "shell.nix", ".git", ".hg"]
        args = ["--log=error", "--semantic-tokens"]
    }

    # by default lsp completion doesn't kick in if preceding key is whitespace
    # nixd can do that, not sure about other language servers
    set-option buffer lsp_completion_trigger ""
}

hook global WinSetOption filetype=nix %{
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }
}

remove-hooks global lsp-filetype-javascript
hook -group lsp-filetype-javascript global BufSetOption filetype=(?:javascript|typescript) %{
    set-option buffer lsp_servers %{
        [typescript-go]
        root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git", ".hg"]
        command = "tsgo"
        args = ["--lsp", "--stdio"]
    }
}
