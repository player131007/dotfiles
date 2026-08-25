define-command -hidden set--nixfmt-formatcmd %{
    set-option buffer formatcmd %sh{
        printf "%s" "nixfmt --filename=${kak_quoted_bufname} --indent=${kak_opt_indentwidth}"
    }
}

hook global BufSetOption filetype=nix %{
    set-option buffer path '%/'
    set-option buffer indentwidth 2
    set-option buffer tabstop %opt{indentwidth}

    set-option buffer comment_block_begin '/*'
    set-option buffer comment_block_end '*/'

    set--nixfmt-formatcmd
    hook buffer -group autoformat -always BufSetOption indentwidth=[0-9]+ set--nixfmt-formatcmd
    hook buffer -group autoformat BufWritePre .* format
    hook -once -always buffer BufSetOption filetype=.* %{
        remove-hooks buffer autoformat
    }
}

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
