{
  flake.modules.nixos."nixosConfigurations/tahari" =
    { lib, ... }:
    {
      boot.supportedFilesystems.zfs = lib.mkForce false;
    };
}
