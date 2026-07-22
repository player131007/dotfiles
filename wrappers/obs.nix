{ lib, types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    plugins = {
      type = types.listOf types.derivation;
      default = [ ];
      description = "List of plugins to be injected into the wrapped package.";
      mutators = [
        "/obs"
        "/looking-glass"
      ];
      mutatorType = types.listOf types.derivation;
      mergeFunc = lib.merge.lists.concat;
    };

    package = {
      type = types.derivation;
      defaultFunc = { inputs }: inputs.nixpkgs.pkgs.obs-studio;
      description = "The obs-studio package to be wrapped.";
    };
  };

  mutations."/obs".plugins = { inputs }: [
    inputs.nixpkgs.pkgs.obs-studio-plugins.obs-pipewire-audio-capture
  ];

  impl =
    { options, inputs }:
    inputs.mkWrapper {
      inherit (options) package;

      environment =
        let
          plugins = inputs.nixpkgs.pkgs.symlinkJoin {
            name = "obs-plugins";
            paths = [ options.plugins ];
          };
        in
        {
          # OBS segfaults if OBS_PLUGINS_PATH is $out/lib/obs-plugins
          OBS_PLUGINS_PATH = "${plugins}/lib/obs-plugins";
          OBS_PLUGINS_DATA_PATH = "${plugins}/share/obs/obs-plugins";
        };

      wrapperArgs =
        let
          inherit (inputs.nixpkgs) lib;
        in
        lib.pipe options.plugins [
          (builtins.concatMap (plugin: plugin.obsWrapperArguments or [ ]))
          lib.lists.uniqueStrings
          (builtins.concatStringsSep " ")
        ];
    };
}
