define-command -docstring "expandtab: use space character to indent and align" expandtab %{
    set-option buffer aligntab false

    remove-hooks buffer expandtab
    hook -group expandtab buffer InsertChar '\t' %{ execute-keys -draft "h%opt{indentwidth}@" }
    hook -group expandtab buffer InsertDelete ' ' %{ try %sh{
        if [ $kak_opt_tabstop -gt 1 ]; then
            printf "%s\n" 'execute-keys -draft -itersel "<a-h><a-k>^\h+.\z<ret>I<space><esc><lt>"'
        fi
    } catch %{ try %{
        execute-keys -itersel -draft "h%opt{tabstop}<s-h>2<s-l>s\h+\z<ret>d"
    }}}
}
