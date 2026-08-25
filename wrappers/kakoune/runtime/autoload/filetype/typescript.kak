hook global BufSetOption filetype=typescript %{
  set-option buffer indentwidth 4
  set-option buffer tabstop %opt{indentwidth}
}

