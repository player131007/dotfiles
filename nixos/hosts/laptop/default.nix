{ pkgs, inputs, host, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./users.nix
    ];

    nix.registry.nixpkgs.to = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-unstable";
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = prev: {
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

    networking.hostName = host;
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

    fonts.packages = with pkgs; [
    	cantarell-fonts
        inter
        (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "Meslo" ]; })
    ];

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

    i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [ fcitx5-unikey ];
    };

    modules.eza.enable = true;
    modules.swaylock.enable = true;
    programs = {
        starship = {
            enable = true;
        };
        neovim = {
            enable = true;
            defaultEditor = true;
        };
        fish.enable = true;
        hyprland.enable = true;
    };
    environment.systemPackages = with pkgs; [
        # development stuffs
        gitMinimal
        clang_16
        llvmPackages_16.libllvm

        # LSPs
        nil
        clang-tools_16 # clangd

        inputs.home-manager.packages.${pkgs.system}.home-manager
        inputs.ags.packages.${pkgs.system}.default
        firefox
        dunst
        swaybg
        grim
        slurp
        brightnessctl

        starship
        wl-clipboard
        foot
        gitMinimal
        ripgrep
        xdg-utils
        btop
        fishPlugins.puffer
        _7zz
        wl-screenrec
    ];

    system.stateVersion = "23.05";
}
