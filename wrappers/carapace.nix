{ types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
    fish.from = { parent }: parent.fish;
  };

  options = {
    package = {
      type = types.derivation;
      defaultFunc = { inputs }: inputs.nixpkgs.pkgs.carapace;
    };
  };

  mutations."/bash".interactiveShellInit =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };
    in
    /* bash */ ''
      eval "$(${getExe finalWrapper} _carapace bash)"
    '';

  mutations."/nushell".sourceFiles =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };
      fish = inputs.fish { };

      completions-nu = inputs.nixpkgs.pkgs.writeText "completions.nu" ''
        let bin = ($env.XDG_CONFIG_HOME? | default ([ $env.HOME ".config" ] | path join)) | path join "carapace/bin"
        $env.PATH = $env.PATH | prepend $bin

        load-env {
          CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq | str join "\n")
          CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq | str join "\n")
        }

        let fish_completer = {|spans|
          ${getExe fish} --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
          | from tsv --flexible --noheaders --no-infer
          | rename value description
          | update value {|row|
            let value = $row.value
            let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
            if ($need_quote and ($value | path exists)) {
              let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
              $'"($expanded_path | str replace --all "\"" "\\\"")"'
            } else {$value}
          }
        }

        let carapace_completer = {|spans|
          ${getExe finalWrapper} $spans.0 nushell ...$spans | from json
        }

        $env.config.completions.external = {
          enable: true
          max_results: 50
          completer: {|spans|
            if ($spans.0 == "nix"
                and $spans.1 in [ "shell" "develop" ]
                and ("-c" in $spans or "--command" in $spans)
               ) {
              $spans | skip until {|arg| $arg in ["-c" "--command"]} | skip
            } else $spans | let $spans

            match $spans.0 {
              git | nix => $fish_completer
              _ => $carapace_completer
            } | do $in $spans
          }
        }
      '';
    in
    [ completions-nu ];

  impl =
    { options, inputs }:
    inputs.mkWrapper {
      inherit (options) package;

      environment = {
        CARAPACE_ENV = "0";
        CARAPACE_LENIENT = "1";
        CARAPACE_EXCLUDES = "nix,git";
      };
    };
}
