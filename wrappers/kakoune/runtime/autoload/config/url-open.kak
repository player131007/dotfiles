declare-option -docstring "Command for opening URLs." str url_open_cmd
define-command -docstring %{
    Open the URL under the cursors with url_open_cmd.
} url-open %{
    evaluate-commands -save-regs 'ab' %{
        set-register b 'https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&/=]*)'
        try %{
            execute-keys -draft '<a-a><a-w>s<c-r>b<ret>"ay'
        } catch %{
            fail 'No URL found!'
        }
        nop %sh{
            eval set -- "$kak_quoted_reg_a"
            while [ $# -gt 0 ]; do
                # strip trailing punctuation
                clean_url="$(echo "$1" | sed 's/[][(){}.,;!?]*$//')"
                shift
                if ! eval "$(printf "$kak_opt_url_open_cmd" "$clean_url")"; then
                    echo "fail 'failed to open url $clean_url'" > "$kak_command_fifo"
                    exit
                fi
            done
        }
    }
}
