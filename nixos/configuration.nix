{ pkgs, inputs, host, ... }:

{
    imports = [
        ./partitioning.nix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
        (final: prev: {
            _7zz = prev._7zz.override {
                enableUnfree = true;
            };
        })
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/efi";

    networking.hostName = host;
    networking.networkmanager.enable = true;
    networking.networkmanager.insertNameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
    ];

    time.timeZone = "Asia/Ho_Chi_Minh";

    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
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
    };

    hardware.bluetooth.enable = true;
    hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
            mesa
        ];
    };

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
    };
    services.auto-cpufreq.enable = true;

    i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
            fcitx5-unikey
    	];
    };

    services.greetd = {
        enable = true;
        vt = 2;
        settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t -r -g \"hi\" -c Hyprland --asterisks --user-menu";
    };

    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;
    programs.fish.enable = true;
    programs.hyprland.enable = true;
    security.pam.services.swaylock = {};
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

        wl-clipboard
        foot
        gitMinimal
        ripgrep
        eza
        xdg-utils
        btop
        pciutils
        fishPlugins.puffer
        _7zz
        libva-utils
        wl-screenrec
    ];

    system.stateVersion = "23.05";
}
