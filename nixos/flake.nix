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
    };

    outputs = inputs@{self, home-manager, nixpkgs, impermanence, ...}: 
    let
        hosts = [ "laptop" ];
    in
    {
        nixosConfigurations = nixpkgs.lib.genAttrs hosts (host: nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs host; };
            modules = [
                impermanence.nixosModule
                home-manager.nixosModule
                ./configuration.nix
                (./. + "/${host}")
            ];  
        });
    };
}
