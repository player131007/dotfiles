{ pkgs, config, inputs, host, ... }:

let
    # you might want to change this
    starship_config = builtins.fromTOML (builtins.readFile (/. + "${config.users.users.player131007.home}/.config/starship.toml"));
in
{
    # you might also want to change these
    imports = [
        ./partitioning.nix
    ];
    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
    };

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
        pam.services.swaylock = {};
    };

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
    };
    hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
        ];
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

    programs = {
        starship = {
            enable = true;
            settings = starship_config;
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

        inputs.ags.packages.${pkgs.system}.default
        firefox
        swaylock
        dunst
        swaybg
        grim
        slurp

        starship
        wl-clipboard
        foot
        gitMinimal
        ripgrep
        eza
        xdg-utils
        btop
        fishPlugins.puffer
        _7zz
        wl-screenrec
    ];

    system.stateVersion = "23.05";
}
