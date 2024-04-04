{ pkgs, config, modulesPath, lib, ... }: {
    imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    # the nixpkgs flake is pinned by default
    nix.channel.enable = false;

    # disabling channels unsets nix-path in nix.conf, we have to set it here
    nix.settings.nix-path = config.nix.nixPath;


    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = prev: {
            gitMinimal = prev.gitMinimal.override {
                withManual = true;
                doInstallCheck = false;
            };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

    # no zfs
    boot.supportedFilesystems.zfs = lib.mkForce false;

    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager
    ];

    isoImage.squashfsCompression = "zstd -Xcompression-level 10";
}
