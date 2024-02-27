{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        impermanence.url = "github:nix-community/impermanence";
        ags = {
            url = "github:Aylur/ags";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        base16.url = "github:SenchoPens/base16.nix";
        base16-schemes = {
            url = "github:tinted-theming/schemes";
            flake = false;
        };

        base16-foot = {
            url = "github:tinted-theming/base16-foot";
            flake = false;
        };
    };

    outputs = inputs@{ nixpkgs, home-manager, ... }: {
        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/laptop ];
        };

        nixosImages.laptop = (nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
                ({ modulesPath, ... }: {
                    imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix") ];
                })
                ./hosts/laptop/minimal.nix
            ];
        }).config.system.build.isoImage;

        homeConfigurations.player131007 = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./users/player131007 ];
        };
    };
}
