; copy-pasted from nvim-treesitter
;
((comment) @injection.content
  (#set! injection.language "comment"))

((comment) @injection.language
  . ; this is to make sure only adjacent comments are accounted for the injections
  (_
    ((string_fragment) @injection.content
      (_)*)+) ; capture all string fragments inside
  (#gsub! @injection.language "^/%*%s*([%w%p]+)%s*%*/$" "%1")
  (#gsub! @injection.language "^#%s*([%w%p]+)%s*$" "%1"))

(apply_expression
  function: [
    (variable_expression
      (identifier) @_func)
    (select_expression
      attrpath: (attrpath
        (identifier) @_func .))
  ]
  .
  argument: (_
    ((string_fragment) @injection.content
      (_)*)+)
  (#eq? @_func "match")
  (#set! injection.language "regex"))

(binding
  attrpath: (attrpath
    (identifier) @_attr .)
  .
  expression: (_
    ((string_fragment) @injection.content
      (_)*)+)
  (#any-of? @_attr
    "unpackPhase" "patchPhase" "configurePhase" "buildPhase" "checkPhase" "installPhase"
    "fixupPhase" "installCheckPhase" "distPhase" "preUnpack" "prePatch" "preConfigure" "preBuild"
    "preCheck" "preInstall" "preFixup" "preInstallCheck" "preDist" "postUnpack" "postPatch"
    "postConfigure" "postBuild" "postCheck" "postInstall" "postFixup" "postInstallCheck" "postDist"
    "script")
  (#set! injection.language "bash"))

(apply_expression
  function: [
    (variable_expression
      (identifier) @_func)
    (select_expression
      attrpath: (attrpath
        (identifier) @_func .))
  ]
  .
  argument: (attrset_expression
    (binding_set
      (binding
        attrpath: (attrpath
          (identifier) @_attr .)
        expression: (_
          ((string_fragment) @injection.content
            (_)*)+))))
  (#eq? @_func "writeShellApplication")
  (#eq? @_attr "text")
  (#set! injection.language "bash"))

(apply_expression
  function: (apply_expression
    function: (apply_expression
      function: [
        (variable_expression
          (identifier) @_func)
        (select_expression
          attrpath: (attrpath
            (identifier) @_func .))
      ]))
  .
  argument: (_
    ((string_fragment) @injection.content
      (_)*)+)
  (#lua-match? @_func "^runCommand")
  (#not-eq? @_func "runCommandWith")
  (#set! injection.language "bash"))

(apply_expression
  function: [
    (variable_expression
      (identifier) @_func)
    (select_expression
      attrpath: (attrpath
        (identifier) @_func .))
  ]
  .
  argument: (attrset_expression
    (binding_set
      (binding
        attrpath: (attrpath
          .
          (identifier) @_dest
          .
          (#eq? @_dest "destination"))
        expression: ((string_expression) @injection.filename
          (#gsub! @injection.filename "^\"(.*)\"$" "%1")))
      (binding
        attrpath: (attrpath
          .
          (identifier) @_attr .)
        expression: (_
          ((string_fragment) @injection.content
            (_)*)+))))
  (#eq? @_func "writeTextFile")
  (#eq? @_attr "text"))

(apply_expression
  function: (apply_expression
    function: [
      (variable_expression
        (identifier) @_func)
      (select_expression
        attrpath: (attrpath
          (identifier) @_func .))
    ]
    argument: ((string_expression) @injection.filename
      (#gsub! @injection.filename "^\"(.*)\"$" "%1")))
  .
  argument: (_
    ((string_fragment) @injection.content
      (_)*)+)
  (#any-of? @_func "writeText" "writeTextDir"))

; other functions that i'm too lazy to add here
; https://github.com/NixOS/nixpkgs/blob/3ec60639c8877d9da2355eb15b1cd14b2433b6fc/pkgs/build-support/writers/scripts.nix
