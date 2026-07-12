{ pkgs, ... }:
{
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
