{ lib, ... }:
with builtins;
let
    fileNames = filter (name: name != ".config") (attrNames (readDir ./home));
    configFileNames =  attrNames (readDir ./home/.config);
in
{
    programs.home-manager.enable = true;
    home.file = lib.genAttrs fileNames (name: { source = ./home + "/${name}"; });
    xdg.configFile = lib.genAttrs configFileNames (name: { source = ./home/.config + "/${name}"; });
    home.stateVersion = "23.05";
}
