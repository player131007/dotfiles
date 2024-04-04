# common stuff between the two
{ pkgs, config, ... }: {
    # the nixpkgs flake is pinned by default
    nix.channel.enable = false;

    # disabling channels unsets nix-path in nix.conf, we have to set it here
    nix.settings.nix-path = config.nix.nixPath;

    nixpkgs.hostPlatform = "x86_64-linux";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = prev: {
            gitMinimal = prev.gitMinimal.override { withManual = true; };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager
    ];
}
