{ config, pkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    channel.enable = false;

    settings.experimental-features = [
      "nix-command"
      "flakes"
      {
        nix = "pipe-operators";
        lix = "pipe-operator";
      }
      .${config.nix.package.pname}
    ];

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };
}
