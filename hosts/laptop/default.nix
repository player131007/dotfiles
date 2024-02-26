{ pkgs, inputs, config, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./apps
    ];

    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
    };

    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
    nix.channel.enable = false;

    # here because `nix.channel.enable = false` would set this to nothing
    nix.settings.nix-path = config.nix.nixPath;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        cudaSupport = true;
        packageOverrides = prev: {
            gitMinimal = prev.gitMinimal.override { withManual = true; };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    boot.loader = {
        systemd-boot = {
            enable = true;
            configurationLimit = 5;
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/efi";
        };
    };

    networking.hostName = "laptop";
    networking.networkmanager.enable = true;
    networking.networkmanager.insertNameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
    ];

    time.timeZone = "Asia/Ho_Chi_Minh";

    console = {
        packages = [ pkgs.powerline-fonts ];
        font = "ter-powerline-v14b";
    };

    security = {
        sudo.enable = false;
        doas = {
            enable = true;
            extraRules = [{ groups = ["wheel"]; persist = true; }];
        };
        rtkit.enable = true;
    };

    services = {
        upower = {
            enable = true;
            percentageLow = 20;
            percentageCritical = 10;
            percentageAction = 0;
            criticalPowerAction = "PowerOff";
        };
        pipewire = {
            enable = true;
            pulse.enable = true;
            alsa.enable = true;
        };
        greetd = {
            enable = true;
            vt = 2;
            settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t -c Hyprland --asterisks --user-menu";
        };
    };

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
        ];
    };

    system.stateVersion = "23.05";
}
