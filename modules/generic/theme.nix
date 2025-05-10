nix-colors:
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.colorScheme = {
    system = lib.mkOption {
      type = lib.types.enum [
        "base16"
        "base24"
      ];
    };

    __functor = lib.mkOption {
      internal = true;
      readOnly = true;
      visible = false;
    };
  };

  config.colorscheme = {
    system = "base24";
    name = "Catppuccin Mocha";
    slug = "catppuccin-mocha";
    author = "https://github.com/catppuccin/catppuccin";
    variant = "dark";
    palette = {
      base00 = "#1e1e2e";
      base01 = "#181825";
      base02 = "#313244";
      base03 = "#45475a";
      base04 = "#585b70";
      base05 = "#cdd6f4";
      base06 = "#f5e0dc";
      base07 = "#b4befe";
      base08 = "#f38ba8";
      base09 = "#fab387";
      base0A = "#f9e2af";
      base0B = "#a6e3a1";
      base0C = "#94e2d5";
      base0D = "#89b4fa";
      base0E = "#cba6f7";
      base0F = "#f2cdcd";
      base10 = "#181825";
      base11 = "#11111b";
      base12 = "#eba0ac";
      base13 = "#f5e0dc";
      base14 = "#a6e3a1";
      base15 = "#89dceb";
      base16 = "#74c7ec";
      base17 = "#f5c2e7";
    };

    # if it works, it works
    __functor =
      self:
      {
        template,
        extension,
      }:
      let
        scheme-meta =
          (lib.pipe
            [ "name" "author" "description" "slug" "system" "variant" ]
            [
              (map (x: lib.nameValuePair "scheme-${x}" self.${x}))
              builtins.listToAttrs
            ]
          )
          // {
            scheme-slug-underscored = builtins.replaceStrings [ "-" ] [ "_" ] self.slug;
            scheme-is-dark-variant = self.variant == "dark";
            scheme-is-light-variant = self.variant == "light";
          };

        generate-colors =
          base-name: value:
          let
            inherit (nix-colors.lib.conversions) hexToDec;
            color-types = rec {
              hex = map (x: builtins.substring x 2 value) [ 0 2 4 ];
              rgb = map hexToDec hex;
              rgb16 = map (x: x * 256) rgb;
              dec = map (x: x / 255.0) rgb;
            };
          in
          {
            "${base-name}-hex" = value;
            "${base-name}-hex-bgr" = lib.concatStrings (lib.reverseList color-types.hex);
          }
          // lib.concatMapAttrs (type: value: {
            "${base-name}-${type}-r" = lib.elemAt value 0;
            "${base-name}-${type}-g" = lib.elemAt value 1;
            "${base-name}-${type}-b" = lib.elemAt value 2;
          }) color-types;
        builder-attrs = scheme-meta // lib.concatMapAttrs generate-colors self.palette;
      in
      pkgs.runCommand "${self.system}-${self.slug}.${extension}" {
        passAsFile = [ "jsonBuilderAttrs" ];
        jsonBuilderAttrs = builtins.toJSON builder-attrs;
      } "${lib.getExe pkgs.mustache-go} $jsonBuilderAttrsPath ${template} > $out";
  };
}
