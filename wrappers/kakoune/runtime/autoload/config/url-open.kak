declare-option -docstring %{
    Command for opening URLs.
} str url_open_cmd 'xdg-open %s'
define-command -docstring %{
    Open the URL the cursor is on with url_open_cmd.
} url-open %{
    evaluate-commands -save-regs 'ab' %{
        set-register b 'https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&/=]*)'
        try %{
            execute-keys -draft '<a-a><a-w>s<c-r>b<ret>"ay'
        } catch %{
            fail 'No URL found!'
        }
        evaluate-commands %sh{
            # run in background
            setsid --fork -- "${KAKOUNE_POSIX_SHELL}" -s 1<&- 2<&- <<- 'EOF'
                eval set -- "$kak_quoted_reg_a"
                while [ $# -gt 0 ]; do
                    # strip trailing punctuation
                    clean_url="$(echo "$1" | sed 's/[][(){}.,;!?]*$//')"
                    shift
                    if ! eval "$(printf "$kak_opt_url_open_cmd" "$clean_url")" >/dev/null 2>&1; then
                        echo "fail 'failed to open url $clean_url'" > "$kak_command_fifo"
                        exit
                    fi
                done
            EOF
        }
    }
}
