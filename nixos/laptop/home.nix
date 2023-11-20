{ lib, ... }:
let
    link = {name, prefix ? ""}: {
        inherit name;
        value.source = ./home + "/${prefix}/${name}";
    };
    files = [ {name = ".gtkrc-2.0";} {name = ".icons";} {name = ".mozilla";} {name = ".themes";} ];
    configFiles = builtins.map (name: {
        inherit name;
        prefix = ".config";
    }) (builtins.attrNames (builtins.readDir ./home/.config));
in
{
    home-manager.useGlobalPkgs = true;
    home-manager.users.player131007 = {
        home.file = builtins.listToAttrs (builtins.map link files);
	xdg.configFile = builtins.listToAttrs (builtins.map link configFiles);
        home.stateVersion = "23.05";
    };
}
