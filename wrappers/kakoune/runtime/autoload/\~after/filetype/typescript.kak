hook global BufSetOption filetype=typescript %{
  set-option buffer indentwidth 4
  set-option buffer tabstop %opt{indentwidth}
}

remove-hooks global lsp-filetype-javascript
hook -group lsp-filetype-javascript global BufSetOption filetype=(?:javascript|typescript) %{
    set-option buffer lsp_servers %{
        [typescript-go]
        root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git", ".hg"]
        command = "tsgo"
        args = ["--lsp", "--stdio"]
    }
}
