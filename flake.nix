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
        schizofox = {
            url = "github:schizofox/schizofox";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
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

    outputs = inputs@{ nixpkgs, ... }: {
        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
                host = "laptop";
            };
            modules = [
                ./hosts/laptop
            ];
        };
    };
}
