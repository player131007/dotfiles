{
  flake.modules.maid.programs =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.programs.helix;
      toml = pkgs.formats.toml { };
    in
    {
      options.programs.helix = {
        enable = lib.mkEnableOption "Helix";

        package = lib.mkPackageOption pkgs "helix" { };

        settings = lib.mkOption {
          type = toml.type;
          default = { };
          example = {
            editor = {
              line-number = "relative";
              editor.statusline.left = [
                "mode"
                "spinner"
              ];
            };
          };
          description = ''
            The editor configuration converted into TOML and written to
            {file}`$XDG_CONFIG_HOME/helix/config.toml`. Please reference
            [Helix's documentation] for config options.

            [Helix's documentation]: https://docs.helix-editor.com/editor.html
          '';
        };

        languages = lib.mkOption {
          type = toml.type;
          default = { };
          example = {
            language-server.vscode-json-language-server.command = "vscode-json-languageserver";
          };
          description = ''
            The languages configurations converted into TOML and written to
            {file}`$XDG_CONFIG_HOME/helix/languages.toml`. Please reference
            [Helix's language documentation] for config options.

            [Helix's language documentation]: https://docs.helix-editor.com/languages.html
          '';
        };

        themes = lib.mkOption {
          type = lib.types.attrsOf toml.type;
          default = { };
          example = {
            theme1 = {
              "ui.background" = "white";
              "ui.text" = "black";
              palette = {
                white = "#ffffff";
                black = "#000000";
              };
            };
          };
          description = ''
            The custom themes converted into TOML and written to
            {file}`$XDG_CONFIG_HOME/helix/themes/`. Please reference
            [Helix's theming documentation] for config options.

            [Helix's theming documentation]: https://docs.helix-editor.com/themes.html
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];

        file.xdg_config =
          {
            "helix/config.toml".source = toml.generate "helix-config.toml" cfg.settings;
            "helix/languages.toml".source = toml.generate "helix-languages.toml" cfg.languages;
          }
          // lib.mapAttrs' (name: theme: {
            name = "helix/themes/${name}.toml";
            value.source = toml.generate "helix-theme-${name}.toml" theme;
          }) cfg.themes;
      };
    };
}
