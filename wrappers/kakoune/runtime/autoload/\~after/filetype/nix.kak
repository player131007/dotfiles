hook global BufSetOption filetype=nix %{
  set-option buffer path '%/'
  set-option buffer indentwidth 2
  set-option buffer tabstop %opt{indentwidth}

  set-option buffer comment_block_begin '/*'
  set-option buffer comment_block_end '*/'

  set-option buffer formatcmd 'nixfmt --indent=${kak_opt_indentwidth} --filename=${kak_quoted_bufname}'
  hook buffer -group autoformat BufWritePre .* format
}

remove-hooks global lsp-filetype-nix
hook -group lsp-filetype-nix global BufSetOption filetype=nix %{
    set-option buffer lsp_servers %{
        [nixd]
        root_globs = ["flake.nix", "shell.nix", ".git", ".hg"]
        args = ["--log=error"]
    }

    # by default lsp completion doesn't kick in if preceding key is whitespace
    # nixd can do that, not sure about other language servers
    set-option buffer lsp_completion_trigger ""
}
