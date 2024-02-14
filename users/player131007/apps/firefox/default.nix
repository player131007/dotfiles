args@{ config, pkgs, lib, ... }: {
    programs.firefox = {
        enable = true;
        package = import ./package.nix args;
    };
}
