{ pkgs, config, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./common.nix
        ./apps
    ];

    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
    };

    nix.channel.enable = false;
    nixpkgs.config.cudaSupport = true;

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

    system.activationScripts = {
        run-nix-index.text = ''
            echo -e '\033[31;1m!!!\033[0m' remember to run nix-index if u updated nixpkgs
            sleep 0.5
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

    system.stateVersion = "23.05";
}
