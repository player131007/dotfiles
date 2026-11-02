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
    fish.from = { parent }: parent.fish;
  };

  options = {
    settings = {
      type = types.attrs;
      default = promise (import ./settings.nix);
    };
    configFile.type = types.pathLike;

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.foot);
    };
  };

  assertions = [
    (assertions.disjoint "settings" "configFile")
  ];

  inputs.mkWrapper.options = promise (
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.pkgs) formats lib;
      generator = formats.ini {
        listsAsDuplicateKeys = true;
      };
    in
    lib.fix (self: {
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

      flags = lib.optionals (self.symlinks."$out/foot.ini" != null) [ "--config=$out/foot.ini" ];
    })
  );

  result = promise ({ results }: results.mkWrapper);
}
