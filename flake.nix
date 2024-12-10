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
        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            modules = [
                inputs.lix-module.nixosModules.default
                inputs.impermanence.nixosModule
                inputs.base16.nixosModule
                inputs.nixvirt.nixosModules.default
                ./hosts/laptop
                ./modules/nixos
                { virtualisation.libvirtd.package = inputs.nixpkgs-libvirt.legacyPackages.x86_64-linux.libvirt; }
            ];
        };

        nixosImage = (nixpkgs.lib.nixosSystem {
            pkgs = self.nixosConfigurations.laptop.pkgs;
            modules = [ ./hosts/iso.nix ];
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
