{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    outputs = { self, nixpkgs, home-manager, impermanence, base16, lix-module }: {
        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            modules = [
                lix-module.nixosModules.default
                impermanence.nixosModule
                base16.nixosModule
                ./hosts/laptop
                ./modules/nixos
            ];
        };

        nixosImage = (nixpkgs.lib.nixosSystem {
            pkgs = self.nixosConfigurations.laptop.pkgs;
            modules = [ ./hosts/iso.nix ];
        }).config.system.build.isoImage;

        homeConfigurations."player131007@laptop" = home-manager.lib.homeManagerConfiguration {
            pkgs = self.nixosConfigurations.laptop.pkgs;
            modules = [
                base16.homeManagerModule
                ./users/player131007
            ];
        };
    };
}
