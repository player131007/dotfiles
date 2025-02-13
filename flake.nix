{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-libvirt.url = "github:NixOS/nixpkgs/4aa36568d413aca0ea84a1684d2d46f55dbabad7";

        nixvirt = {
            url = "github:AshleyYakeley/NixVirt/v0.5.0";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-ovmf.follows = "nixpkgs";
        };
        impermanence.url = "github:nix-community/impermanence";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        lix-module = {
            url = "git+https://git.lix.systems/lix-project/nixos-module?ref=stable&shallow=1";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        base16.url = "github:SenchoPens/base16.nix";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {
        overlays = let
            inherit (nixpkgs) lib;
            allOverlays = lib.pipe ./overlays [
                builtins.readDir
                builtins.attrNames
                (map (lib.path.append ./overlays))
                (map import)
            ];
        in {
            default = lib.composeManyExtensions allOverlays;
        };

        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            modules = [
                inputs.lix-module.nixosModules.default
                inputs.impermanence.nixosModule
                inputs.base16.nixosModule
                inputs.nixvirt.nixosModules.default
                ./hosts/laptop
                ./modules/nixos/base.nix
                ./modules/nixos/oh-my-posh.nix
                ./modules/nixos/dwl.nix
                {
                    virtualisation.libvirtd.package = inputs.nixpkgs-libvirt.legacyPackages.x86_64-linux.libvirt;
                    nixpkgs.overlays = [ self.overlays.default ];
                }
            ];
        };

        nixosImage = (nixpkgs.lib.nixosSystem {
            modules = [
                ./modules/nixos/base.nix
                ./hosts/iso.nix
            ];
        }).config.system.build.isoImage;

        homeConfigurations."player131007@laptop" = home-manager.lib.homeManagerConfiguration {
            pkgs = self.nixosConfigurations.laptop.pkgs;
            modules = [
                inputs.base16.homeManagerModule
                ./users/player131007
            ];
        };
    };
}
