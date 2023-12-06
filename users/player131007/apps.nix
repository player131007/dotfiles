{ pkgs, inputs, ... }:
{
    imports = [
        ../../apps/hm
        inputs.ags.homeManagerModules.default
    ];

    programs = {
        neovim = {
            enable = true;
            defaultEditor = true;
        };
        ags.enable = true;
        bash.enable = true;
    };

    home.packages = with pkgs; [
        gitMinimal
        clang_16
        llvmPackages_16.libllvm

        nil
        clang-tools_16 # clangd

        dunst
        swaybg
        grim
        slurp
        brightnessctl

        wl-clipboard
        foot
        ripgrep
        xdg-utils
        btop
        _7zz
        wl-screenrec
    ];
}
