# things to put on an iso image
{ inputs, config, pkgs, lib, ... }: {
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
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

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

    hardware.cpu.amd.updateMicrocode = true;
    hardware.firmware = with pkgs; [
        linux-firmware
    ];

    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager
    ];
}
