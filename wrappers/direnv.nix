# TODO: remove most of this when i update adios-wrappers
{ types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
    self.from = { parent }: parent.self;
  };

  options = {
    nix-direnv = {
      type = types.derivation;
      defaultFunc = { inputs }: inputs.self.pkgs.nix-direnv;
    };

    settings.default = {
      global.hide_env_diff = true;
    };
  };

  # direnv just straight up hard-codes the executable path
  # so i hard-coded the hooks

  mutations."/bash".interactiveShellInit =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };
    in
    /* bash */ ''
      _direnv_hook() {
        local previous_exit_status=$?;
        trap -- ''' SIGINT;
        eval "$(${getExe finalWrapper} export bash)";
        trap - SIGINT;
        return $previous_exit_status;
      };
      if [[ ";''${PROMPT_COMMAND[*]:-};" != *";_direnv_hook;"* ]]; then
        if [[ "$(declare -p PROMPT_COMMAND 2>&1)" == "declare -a"* ]]; then
          PROMPT_COMMAND=(_direnv_hook "''${PROMPT_COMMAND[@]}")
        else
          PROMPT_COMMAND="_direnv_hook''${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
        fi
      fi
    '';

  mutations."/fish".interactiveShellInit =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };
    in
    /* fish */ ''
      function __direnv_export_eval --on-event fish_prompt;
        ${getExe finalWrapper} export fish | source;

        if test "$direnv_fish_mode" != "disable_arrow";
          function __direnv_cd_hook --on-variable PWD;
            if test "$direnv_fish_mode" = "eval_after_arrow";
              set -g __direnv_export_again 0;
            else;
              ${getExe finalWrapper} export fish | source;
            end;
          end;
        end;
      end;

      function __direnv_export_eval_2 --on-event fish_preexec;
          if set -q __direnv_export_again;
              set -e __direnv_export_again;
              ${getExe finalWrapper} export fish | source;
              echo;
          end;

          functions --erase __direnv_cd_hook;
      end;
    '';

  mutations."/nushell".sourceFiles =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs;
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };

      direnv-nu = pkgs.writeText "direnv.nu" ''
        $env.config.hooks.pre_prompt = $env.config.hooks.pre_prompt? | default [] | append {||
          ${getExe finalWrapper} export json
          | from json
          | default {}
          | transpose key value
          | update value {|row|
              if $row.key in $env.ENV_CONVERSIONS {
                let path = [ ENV_CONVERSIONS $row.key from_string ] | into cell-path
                  do ($env | get $path) $row.value
              } else $row.value
            }
          | transpose --as-record --header-row | into record # transpose might return empty list
          | load-env
        }
      '';
    in
    [ direnv-nu ];

  impl =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.pkgs) formats writeText;
      inherit (options) nix-direnv;
      generator = formats.toml { };
    in
    assert !(options ? settings && options ? configFile);
    assert !(options ? direnvrc && options ? direnvrcFile);
    inputs.mkWrapper {
      inherit (options) package;
      symlinks = {
        "$out/direnv/direnv.toml" =
          if options ? configFile then
            options.configFile
          else if options ? settings then
            generator.generate "direnv.toml" options.settings
          else
            null;
        # nix-direnv integration
        "$out/direnv/lib/hm-nix-direnv.sh" =
          if nix-direnv != null then "${nix-direnv}/share/nix-direnv/direnvrc" else null;
        "$out/direnv/direnvrc" =
          if options ? direnvrcFile then
            options.direnvrcFile
          else if options ? direnvrc then
            writeText "direnvrc" options.direnvrc
          else
            null;
      };
      environment = {
        XDG_CONFIG_HOME = "$out";
      };
    };
}
