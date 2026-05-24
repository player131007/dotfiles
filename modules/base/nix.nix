{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = lib.singleton (
    final: prev: {
      nix-prefetch-docker = prev.nix-prefetch-docker.override {
        nix = config.nix.package;
      };
    }
  );

  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    channel.enable = false;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };
}
