{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        impermanence.url = "github:nix-community/impermanence";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        base16.url = "github:SenchoPens/base16.nix";
    };

    outputs = { self, nixpkgs, home-manager, impermanence, base16, nixvim }: {
        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            modules = [
                impermanence.nixosModule
                ./hosts/laptop
            ];
        };

        nixosImage = (nixpkgs.lib.nixosSystem {
            modules = [ ./hosts/iso.nix ];
        }).config.system.toplevel.isoImage;

        homeConfigurations.player131007 = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            modules = [
                base16.homeManagerModule
                nixvim.homeManagerModules.nixvim
                ./users/player131007
            ];
        };
    };
}
