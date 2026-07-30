hook global BufSetOption filetype=nix %{
  set-option buffer path '%/'
  set-option buffer indentwidth 2
  set-option buffer tabstop %opt{indentwidth}

  set-option buffer comment_block_begin '/*'
  set-option buffer comment_block_end '*/'

  set-option buffer formatcmd 'nixfmt --indent=${kak_opt_indentwidth} --filename=${kak_quoted_bufname}'
  hook buffer -group autoformat BufWritePre .* format
}
