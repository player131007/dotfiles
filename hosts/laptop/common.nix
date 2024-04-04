# common stuff between the two
{ pkgs, ... }: {
    nixpkgs.flake.setFlakeRegistry = true;
    nixpkgs.flake.setNixPath = true;

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

    hardware.firmware = with pkgs; [
        linux-firmware
    ];

    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager
    ];
}
