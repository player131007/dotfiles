{
  assertions,
  promise,
  types,
  ...
}:
{
  inputs = {
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    settings = {
      type = types.attrs;
      default = {
        win.fullScreen = "yes";
        input.escapeKey = "KEY_INSERT";
        spice = {
          host = "/run/user/1000/windoes/spice.sock";
          port = 0;
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

  # inputs.mkWrapper.options = promise (
  #   { options, inputs }:
  #   let
  #     generator = inputs.nixpkgs.pkgs.formats.ini { };
  #   in
  #   {
  #     inherit (options) package;

  #     symlinks = {
  #       "$out/looking-glass/client.ini" =
  #         if options ? configFile then
  #           options.configFile
  #         else if options ? settings then
  #           generator.generate "client.ini" options.settings
  #         else
  #           null;
  #     };

  #     environment = {
  #       XDG_CONFIG_HOME = "$out";
  #     };

  #     postWrap = /* bash */ ''
  #       for desktopEntry in $out/share/applications/*.desktop; do
  #         if grep -q "${options.package}" "$desktopEntry"; then
  #           cp --no-preserve=mode --remove-destination $(readlink -e "$desktopEntry") $desktopEntry
  #           substituteInPlace "$desktopEntry" \
  #             --replace-quiet "${options.package}" "$out"
  #         fi
  #       done
  #     '';
  #   }
  # );

  result = promise (
    { inputs, options }:
    let
      inherit (inputs.nixpkgs) pkgs lib;
      generator = pkgs.formats.ini { };
      configFile =
        if options ? configFile then
          options.configFile
        else if options ? settings then
          generator.generate "client.ini" options.settings
        else
          null;
    in
    pkgs.symlinkJoin {
      name = "${options.package.pname}-wrapped";
      paths = [ options.package ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild =
        lib.optionalString (configFile != null) ''
          mkdir $out/looking-glass
          ln -s ${configFile} $out/looking-glass/client.ini
        ''
        + ''
          wrapProgram $out/bin/looking-glass-client \
            --set XDG_CONFIG_HOME $out \
            --add-flags 'spice:host="$XDG_RUNTIME_DIR/windoes/spice.sock" spice:port=0'

          desktopEntry=$out/share/applications/looking-glass-client.desktop
          cp --no-preserve=mode --remove-destination $(readlink -e "$desktopEntry") $desktopEntry
          substituteInPlace "$desktopEntry" --replace-warn "${options.package}" "$out"
        '';
    }
  );
}
