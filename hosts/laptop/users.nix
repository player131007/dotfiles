{ inputs, ... }:
{
    imports = [
        inputs.home-manager.nixosModule
    ];

    home-manager.useGlobalPkgs = true;

    home-manager.users.player131007 = import ../../users/player131007 inputs;
    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
        hashedPasswordFile = "/persist/password/player131007";
    };
}
