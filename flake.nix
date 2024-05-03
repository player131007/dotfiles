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

        base16.url = "github:SenchoPens/base16.nix";
    };

    outputs = { self, nixpkgs, home-manager, impermanence, base16, nvim-flake }: {
        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            modules = [
                impermanence.nixosModule
                ./hosts/laptop
            ];
        };

        nixosImage = (nixpkgs.lib.nixosSystem {
            pkgs = self.nixosConfigurations.laptop.pkgs;
            modules = [ ./hosts/iso.nix ];
        }).config.system.build.isoImage;

        homeConfigurations."player131007@laptop" = home-manager.lib.homeManagerConfiguration {
            pkgs = self.nixosConfigurations.laptop.pkgs;
            extraSpecialArgs = { inherit nvim-flake; };
            modules = [
                base16.homeManagerModule
                ./users/player131007
            ];
        };
    };
}
