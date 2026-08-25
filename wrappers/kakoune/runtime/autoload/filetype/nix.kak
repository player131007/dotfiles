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
