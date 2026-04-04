; also copy-pasted from nvim-treesitter
;
((comment) @injection.content
  (#set! injection.language "comment"))

(predicate
  name: (identifier) @_name
  type: (predicate_type) @_type
  parameters: (parameters
    (string
      (string_content) @injection.content))
  (#eq? @_type "?")
  (#gsub! @_name "not%-(.*)" "%1")
  (#gsub! @_name "any%-(.*)" "%1")
  (#any-of? @_name "match" "vim-match")
  (#set! injection.language "regex"))

((predicate
  name: (identifier) @_name
  type: (predicate_type) @_type
  parameters: (parameters
    (string
      (string_content) @injection.content)))
  (#eq? @_type "?")
  (#gsub! @_name "not%-(.*)" "%1")
  (#gsub! @_name "any%-(.*)" "%1")
  (#eq? @_name "lua-match")
  (#set! injection.language "luap"))

((predicate
  name: (identifier) @_name
  type: (predicate_type) @_type
  parameters: (parameters
    (string
      (string_content) @injection.content)))
  (#eq? @_type "!")
  (#eq? @_name "gsub")
  (#set! injection.language "luap"))
