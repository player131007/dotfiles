{ pkgs, inputs, ... }:
{
    imports = [
        ../../apps/nixos
    ];

    programs = {
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
        dunst
        swaybg
        grim
        slurp
        brightnessctl

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
}
