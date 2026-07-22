{ types, ... }: {
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
      defaultFunc = { inputs }: inputs.nixpkgs.pkgs.looking-glass-client;
      description = "The looking-glass-client package to be wrapped";
    };
  };

  mutations."/obs".plugins = { inputs }: [
    inputs.nixpkgs.pkgs.obs-studio-plugins.looking-glass-obs
  ];

  impl =
    { options, inputs }:
    let
      generator = inputs.nixpkgs.pkgs.formats.ini { };

      configFile =
        if options ? configFile then
          options.configFile
        else if options ? settings then
          generator.generate "client.ini" options.settings
        else
          null;
    in
    assert !(options ? settings && options ? configFile);
    inputs.mkWrapper {
      inherit (options) package;

      symlinks = {
        "$out/client.ini" = configFile;
      };

      flags = if configFile != null then [ "app:configFile=$out/client.ini" ] else [ ];
    };
}
