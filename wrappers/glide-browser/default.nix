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

    configFile = {
      type = types.pathLike;
      defaultFunc =
        { inputs }:
        let
          inherit (inputs.nixpkgs) pkgs;

          package =
            {
              stdenvNoCC,
              typescript-go,
              esbuild,
            }:
            stdenvNoCC.mkDerivation {
              name = "glide.ts";
              src = ./config;
              nativeBuildInputs = [
                typescript-go
                esbuild
              ];

              buildCommand = ''
                cd $src
                tsc --noEmit --project ./tsconfig.json
                esbuild --bundle main.ts --outfile=$out
              '';
            };
        in
        pkgs.callPackage package { };
    };

    firefoxVersion = {
      type = types.string;
      default = "153.0b5"; # update when glide-browser updates
    };

    wrapFirefoxArgs = {
      type = types.attrs;
      default = {
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
  };

  impl =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs;
    in
    # since there are version checks in pkgs.wrapFirefox
    # use the firefox version that glide is based on here and override later
    (pkgs.wrapFirefox (options.package // { version = options.firefoxVersion; }) (
      options.wrapFirefoxArgs // { inherit (options.package) version; }
    )).overrideAttrs
      (prev: {
        makeWrapperArgs = prev.makeWrapperArgs or [ ] ++ [
          "--run"
          "export MOZ_APP_DATA=\"\${MOZ_APP_DATA:-\${XDG_CONFIG_HOME:-\${HOME}/.config}/glide/glide}\""
          "--set"
          "XDG_CONFIG_HOME"
          (placeholder "out")
        ];

        buildCommand =
          prev.buildCommand or ""
          + "\n"
          + ''
            mkdir -p $out/glide
            ln -s ${options.configFile} $out/glide/glide.ts
          '';
      });
}
