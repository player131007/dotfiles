{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # TODO: override packages that depend on nix as i encounter them

  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    channel.enable = false;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };
}
