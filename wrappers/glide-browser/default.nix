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

    wrapFirefoxArgs = {
      type = types.attrs;
      defaultFunc =
        { options }:
        {
          inherit (options.package) version;

          extraPrefsFiles = map (file: "${file}") [
            ./prefs/betterfox.js
            ./prefs/smooth_scrolling.js
            ./prefs/prefs.js
          ];
          extraPoliciesFiles = map (file: "${file}") [
            ./policies/policies.json
            ./policies/search_engines.json
            ./policies/extensions.json
          ];
        };
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
      defaultFunc =
        { inputs }:
        let
          inherit (inputs.nixpkgs) pkgs;
        in
        {
          "$out/glide/glide.ts" =
            pkgs.runCommandLocal "glide.ts"
              {
                src = ./config;
                nativeBuildInputs = [
                  pkgs.typescript-go
                  pkgs.esbuild
                ];
              }
              ''
                cd $src
                tsc --noEmit
                esbuild --bundle main.ts --outfile=$out
              '';
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
    (pkgs.wrapFirefox (options.package // { version = "153.0b5"; }) options.wrapFirefoxArgs)
    .overrideAttrs
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
