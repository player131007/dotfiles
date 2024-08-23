{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        impermanence.url = "github:nix-community/impermanence";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nvim-flake = {
            url = "github:player131007/nvim-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        lix-module = {
            url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        base16.url = "github:SenchoPens/base16.nix";
    };

    outputs = { self, nixpkgs, home-manager, impermanence, base16, nvim-flake, lix-module }: {
        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit nvim-flake; };
            modules = [
                lix-module.nixosModules.default
                impermanence.nixosModule
                base16.nixosModule
                ./hosts/laptop
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
