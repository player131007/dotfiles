{
  merge,
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
    plugins = {
      type = types.listOf types.derivation;
      default = [ ];
      description = "List of plugins to be injected into the wrapped package.";
      mutators = [
        "/obs"
        "/looking-glass"
      ];
      mergeFunc = merge.lists.concat;
    };

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.obs-studio);
      description = "The obs-studio package to be wrapped.";
    };
  };

  mutations."/obs".plugins = promise (
    { inputs }: [
      inputs.nixpkgs.pkgs.obs-studio-plugins.obs-pipewire-audio-capture
    ]
  );

  inputs.mkWrapper.options = promise (
    { options, inputs }:
    {
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
        options.plugins
        |> builtins.concatMap (plugin: plugin.obsWrapperArguments or [ ])
        |> lib.lists.uniqueStrings
        |> builtins.concatStringsSep " ";
    }
  );

  result = promise ({ results }: results.mkWrapper);
}
