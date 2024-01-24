{ inputs, ... }: {
    imports = with inputs; [
        home-manager.nixosModule
        (self + "/users/player131007")
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.extraSpecialArgs = { inherit inputs; };

    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
    };
}
