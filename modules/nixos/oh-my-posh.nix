{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.oh-my-posh;

  settingsFormat = pkgs.formats.json { };
  userSettingsFile = settingsFormat.generate "omp.json" cfg.settings;

  command =
    shell:
    "${lib.getExe cfg.package} init ${shell}${
      lib.optionalString (cfg.settings != null) " --config ${userSettingsFile}"
    }";
in
{
  options.programs.oh-my-posh = {
    enable = lib.mkEnableOption "oh-my-posh";
    package = lib.mkPackageOption pkgs "oh-my-posh" { };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.promptInit = ''
      if [[ $TERM != "dumb" ]]; then
        eval "$(${command "bash"})"
      fi
    '';

    programs.fish.promptInit = ''
      if test "$TERM" != "dumb"
        ${command "fish"} | source
      end
    '';

    programs.zsh.promptInit = ''
      if [[ $TERM != "dumb" ]]; then
        eval "$(${command "zsh"})"
      fi
    '';
  };
}
