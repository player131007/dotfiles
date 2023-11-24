{ inputs, ... }:
{
    imports = [
        inputs.home-manager.nixosModule
        ../../users/player131007
    ];

    home-manager.useGlobalPkgs = true;

    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
    };
}
