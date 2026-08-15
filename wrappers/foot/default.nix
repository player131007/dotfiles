{ types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
    nushell.from = { parent }: parent.nushell;
  };

  options = {
    settings = {
      type = types.attrs;
      defaultFunc = import ./settings.nix;
    };
    configFile.type = types.pathLike;

    package = {
      type = types.derivation;
      defaultFunc = { inputs }: inputs.nixpkgs.pkgs.foot;
    };
  };

  impl =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.pkgs) formats;
      generator = formats.ini {
        listsAsDuplicateKeys = true;
      };
    in
    assert !(options ? settings && options ? configFile);
    inputs.mkWrapper rec {
      inherit (options) package;

      symlinks = {
        "$out/foot.ini" =
          if options ? configFile then
            options.configFile
          else if options ? settings then
            generator.generate "foot.ini" options.settings
          else
            null;
      };

      flags = if symlinks."$out/foot.ini" != null then [ "--config=$out/foot.ini" ] else [ ];
    };
}
