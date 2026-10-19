{
  assertions,
  promise,
  types,
  ...
}:
{
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    settings = {
      type = types.attrs;
      default = {
        win.fullScreen = "yes";
        input = {
          escapeKey = "KEY_INSERT";
          rawMouse = "yes";
        };
      };
      description = ''
        Settings to be injected into the wrapped package's config.

        Disjoint with the `configFile` option.
      '';
    };

    configFile = {
      type = types.pathLike;
      description = ''
        Config file to be injected to the wrapped package.

        Disjoint with the `settings` option.
      '';
    };

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.looking-glass-client);
      description = "The looking-glass-client package to be wrapped";
    };
  };

  mutations."/obs".plugins = promise (
    { inputs }: [
      inputs.nixpkgs.pkgs.obs-studio-plugins.looking-glass-obs
    ]
  );

  assertions = [
    (assertions.disjoint "settings" "configFile")
  ];

  inputs.mkWrapper.options = promise (
    { options, inputs }:
    let
      generator = inputs.nixpkgs.pkgs.formats.ini { };
    in
    {
      inherit (options) package;

      symlinks = {
        "$out/looking-glass/client.ini" =
          if options ? configFile then
            options.configFile
          else if options ? settings then
            generator.generate "client.ini" options.settings
          else
            null;
      };

      environment = {
        XDG_CONFIG_HOME = "$out";
      };

      postWrap = /* bash */ ''
        for desktopEntry in $out/share/applications/*.desktop; do
          if grep -q "${options.package}" "$desktopEntry"; then
            cp --no-preserve=mode --remove-destination $(readlink -e "$desktopEntry") $desktopEntry
            substituteInPlace "$desktopEntry" \
              --replace-quiet "${options.package}" "$out"
          fi
        done
      '';
    }
  );

  result = promise ({ results }: results.mkWrapper);
}
