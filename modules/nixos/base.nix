{lib, ...}: {
  nix = {
    channel.enable = lib.mkDefault false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  boot.kernel.sysctl."kernel.dmesg_restrict" = lib.mkDefault 0;
}
