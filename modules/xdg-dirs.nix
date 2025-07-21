{
  flake.modules.nixos.pc =
    { lib, ... }:
    {
      environment.sessionVariables = lib.mapAttrs (_: lib.mkDefault) {
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_CACHE_HOME = "$HOME/.cache";
      };
    };
}
