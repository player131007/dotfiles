{ pkgs, nvim-flake, config, ... }: {
    programs = {
        command-not-found.enable = false;
        nix-index.enable = true;
        starship = {
            enable = true;
            settings = fromTOML (builtins.readFile ./starship.toml);
        };
        fish.enable = true;
        ssh.startAgent = true;

        hyprland.enable = true;
        hyprlock.enable = true;
        virt-manager.enable = true;
    };

    environment.variables.EDITOR = "nvim";
    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager

        eza
        virtiofsd
        (nvim-flake.packages.${pkgs.system}.default.override {
            colorscheme =
            let
                baseXX = lib.filterAttrs (k: _: lib.hasPrefix "base" k && builtins.stringLength k == 6);
            in baseXX config.scheme.withHashtag;
        })
    ];

    environment.shellAliases = {
        ls = "eza --icons -F";
        ll = "eza --icons -F -lhb";
        l = "eza --icons -F -lhba";
    };
}
