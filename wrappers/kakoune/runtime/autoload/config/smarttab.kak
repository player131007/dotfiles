define-command -hidden expandtab-impl %{
    hook -group expandtab buffer InsertChar '\t' %{ execute-keys -draft "h%opt{indentwidth}@" }
    hook -group expandtab buffer InsertDelete ' ' %{ try %{
        execute-keys -draft "<a-h><a-k>^\h+.\z<ret>I<space><esc><lt>"
    }}
}

hook -group smarttab global BufSetOption indentwidth=.* %{
    evaluate-commands %sh{
        if [ "$kak_opt_indentwidth" -ne 0 ]; then
            echo "expandtab-impl"
        else
            echo "remove-hooks buffer expandtab"
        fi
    }
}
