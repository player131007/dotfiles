{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

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

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;

      systems = ["x86_64-linux"];

      imports = [
        ./overlays.nix
        ./modules
        ./hosts
        ./users
      ];
    };
}
