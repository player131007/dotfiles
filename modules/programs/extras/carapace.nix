{ pkgs, lib, ... }:
let
  carapace = lib.getExe pkgs.carapace;
in
{
  environment.sessionVariables = {
    CARAPACE_BRIDGES = "fish,bash";
    CARAPACE_ENV = "0";
    CARAPACE_LENIENT = "1";
    CARAPACE_EXCLUDES = "nix,git";
  };

  programs.bash.interactiveShellInit = /* bash */ ''
    source <(${carapace} _carapace bash)
  '';

  programs.fish.interactiveShellInit = /* fish */ ''
    ${carapace} _carapace fish | source
  '';

  stuff.nushell.vendors = lib.singleton (
    pkgs.writeTextDir "share/nushell/vendor/autoload/completions.nu" /* nu */ ''
      let bin = ($env.XDG_CONFIG_HOME? | default ([ $env.HOME ".config" ] | path join)) | path join "carapace/bin"
      $env.PATH = $env.PATH | prepend $bin

      load-env {
        CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq | str join "\n")
        CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq | str join "\n")
      }

      let fish_completer = {|spans|
        fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
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
        ${carapace} $spans.0 nushell ...$spans | from json
      }

      $env.config.completions.external = {
        enable: true
        max_results: 50
        completer: {|spans|
          match $spans.0 {
            git | nix => $fish_completer
            _ => $carapace_completer
          } | do $in $spans
        }
      }
    ''
  );
}
