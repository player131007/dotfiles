{ types, ... }: {
  inputs = {
    nixpkgs.from = { parent }: parent.nixpkgs;
    self.from = { parent }: parent.self;
  };

  options = {
    package = {
      type = types.derivation;
      defaultFunc = { inputs }: inputs.self.pkgs.glide-browser-bin-unwrapped;
    };

    environment = {
      type = types.attrsOf (types.nullOr types.string);
      default = {
        # $XDG_CONFIG_HOME is read only, so store profiles in the legacy dir ($HOME/.glide/glide)
        MOZ_LEGACY_HOME = "1";
        XDG_CONFIG_HOME = placeholder "out";
      };
    };

    symlinks = {
      type = types.attrsOf (types.nullOr types.pathLike);
      default = {
        "$out/glide/glide.ts" = ./glide.ts;
      };
    };
  };

  impl =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs lib;
      inherit (builtins) attrNames concatMap concatStringsSep;
    in
    # since there are version checks in pkgs.wrapFirefox
    # use the firefox version that glide is based on here and override later
    (pkgs.wrapFirefox (options.package // { version = "153.0b5"; }) {
      inherit (options.package) version;
    }).overrideAttrs
      (prev: {
        makeWrapperArgs =
          prev.makeWrapperArgs or [ ]
          ++ concatMap (
            var:
            let
              value = options.environment.${var};
            in
            lib.optionals (value != null) [
              "--set"
              var
              value
            ]
          ) (attrNames options.environment);

        buildCommand =
          prev.buildCommand or ""
          + "\n"
          + concatStringsSep "\n" (
            concatMap (
              symlink:
              let
                destination = options.symlinks.${symlink};
              in
              lib.optionals (destination != null) [
                "mkdir -p $(dirname ${symlink})"
                "ln -s ${destination} ${symlink}"
              ]
            ) (attrNames options.symlinks)
          );
      });
}
