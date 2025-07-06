{
  flake.modules.maid.programs =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.options) mkEnableOption mkOption mkPackageOption;
      inherit (lib.modules) mkIf;
      inherit (lib.types) lines;

      gitIni = pkgs.formats.gitIni { };
      cfg = config.programs.git;
    in
    {
      options.programs.git = {
        enable = mkEnableOption "git";

        package = mkPackageOption pkgs "git" { };

        settings = mkOption {
          type = gitIni.type;
          default = { };
          example = {
            user = {
              email = "alice@example.com";
              name = "alice";
            };
            init = {
              defaultBranch = "main";
            };
            merge = {
              conflictstyle = "diff3";
            };
            diff = {
              colorMoved = "default";
            };
          };
          description = ''
            Settings that will be written to your configuration file.
          '';
        };

        ignore = mkOption {
          type = lines;
          default = "";
          example = ''
            .direnv
          '';
          description = ''
            Global user-level version of .gitignore written to
            {file}`$XDG_CONFIG_HOME/git/ignore`.
          '';
        };

        attributes = mkOption {
          type = lines;
          default = "";
          example = ''
            # Auto detect text files and perform LF normalization
            * text=auto

            # Detect Markdown files
            *.md linguist-detectable=true
          '';
          description = ''
            Global user-level version of .gitattributes written to
            {file}`$XDG_CONFIG_HOME/git/attributes`.
          '';
        };
      };

      config = mkIf cfg.enable {
        packages = mkIf (cfg.package != null) [ cfg.package ];
        file.xdg_config = {
          "git/config".source = mkIf (cfg.settings != { }) (gitIni.generate "config" cfg.settings);
          "git/ignore".text = mkIf (cfg.ignore != { }) cfg.ignore;
          "git/attributes".text = mkIf (cfg.attributes != { }) cfg.attributes;
        };
      };
    };
}
