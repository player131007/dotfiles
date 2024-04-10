{ pkgs, config, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./apps.nix
    ];

    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
    };

    nix.channel.enable = false;
    nix.settings.nix-path = config.nix.nixPath;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        cudaSupport = true;
        packageOverrides = prev: {
            gitMinimal = prev.gitMinimal.override {
                withManual = true;
                doInstallCheck = false;
            };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    networking.wireless.iwd = {
        enable = true;
        settings = {
            General.EnableNetworkConfiguration = true;
            Scan.DisablePeriodicScan = true;
        };
    };
    networking.dhcpcd.enable = false;
    networking.nameservers = [
        "1.1.1.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
    ];
    services.resolved = {
        enable = true;
        fallbackDns = [
            "9.9.9.9#dns.quad9.net"
            "8.8.8.8#dns.google"
            "2620:fe::9#dns.quad9.net"
            "2001:4860:4860::8888#dns.google"
        ];
    };

    system.activationScripts = {
        run-nix-index.text = ''
            echo -e '\033[31;1m!!!\033[0m' remember to run nix-index if u updated nixpkgs
        '';
    };

    console = {
        packages = [ pkgs.powerline-fonts ];
        font = "ter-powerline-v14b";
    };

    security = {
        sudo = {
            enable = true;
            execWheelOnly = true;
            extraConfig = ''
                Defaults lecture=never
            '';
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
            settings.default_session.command =
            let
                sessions = config.services.xserver.displayManager.sessionData.desktops;
            in "${pkgs.greetd.tuigreet}/bin/tuigreet -t -s ${sessions}/share/xsessions:${sessions}/share/wayland-sessions --asterisks --user-menu";
        };
    };

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
        ];
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
    time.timeZone = "Asia/Ho_Chi_Minh";

    system.stateVersion = "23.05";
}
