{ promise, ... }: {
  inputs = {
    self.from = { parent }: parent.self;
  };

  options = {
    settings.default = {
      global.hide_env_diff = true;
    };
  };

  # direnv just straight up hard-codes the executable path
  # so i hard-coded the hooks

  mutations."/bash".interactiveShellInit = promise (
    { inputs, result }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
    in
    /* bash */ ''
      _direnv_hook() {
        local previous_exit_status=$?;
        trap -- ''' SIGINT;
        eval "$(${getExe result} export bash)";
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
    ''
  );

  mutations."/fish".interactiveShellInit = promise (
    { inputs, result }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
    in
    /* fish */ ''
      function __direnv_export_eval --on-event fish_prompt;
        ${getExe result} export fish | source;

        if test "$direnv_fish_mode" != "disable_arrow";
          function __direnv_cd_hook --on-variable PWD;
            if test "$direnv_fish_mode" = "eval_after_arrow";
              set -g __direnv_export_again 0;
            else;
              ${getExe result} export fish | source;
            end;
          end;
        end;
      end;

      function __direnv_export_eval_2 --on-event fish_preexec;
          if set -q __direnv_export_again;
              set -e __direnv_export_again;
              ${getExe result} export fish | source;
              echo;
          end;

          functions --erase __direnv_cd_hook;
      end;
    ''
  );
}
