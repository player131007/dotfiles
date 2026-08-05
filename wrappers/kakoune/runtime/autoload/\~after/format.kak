define-command -override format-selections -docstring "Format the selections individually" %{
    evaluate-commands %sh{
        if [ -z "${kak_opt_formatcmd}" ]; then
            echo "fail 'The option ''formatcmd'' must be set'"
        fi
    }
    evaluate-commands -draft -no-hooks -save-regs 'e|' %{
        set-register e nop
        set-register '|' %{
            # expose some options
            # $kak_opt_indentwidth
            # $kak_quoted_bufname

            format_in="$(mktemp "${TMPDIR:-/tmp}"/kak-formatter.XXXXXX)"
            format_out="$(mktemp "${TMPDIR:-/tmp}"/kak-formatter.XXXXXX)"

            cat > "$format_in"
            eval "$kak_opt_formatcmd" < "$format_in" > "$format_out"
            if [ $? -eq 0 ]; then
                cat "$format_out"
            else
                echo "set-register e fail formatter returned an error (exit code $?)" >"$kak_command_fifo"
                cat "$format_in"
            fi
            rm -f "$format_in" "$format_out"
        }
        execute-keys '|<ret>'
        %reg{e}
    }
}
