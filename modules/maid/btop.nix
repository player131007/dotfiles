{
  flake.modules.maid.programs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.btop;
      inherit (lib) types;
    in
    {
      options.programs.btop = {
        enable = lib.mkEnableOption "btop";
        package = lib.mkPackageOption pkgs "btop" { };

        settings = lib.mkOption {
          type = types.attrsOf (
            types.oneOf [
              types.bool
              types.float
              types.int
              types.str
            ]
          );
        };
      };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];

        file.xdg_config."btop/btop.conf".text =
          let
            toKeyValue = lib.generators.toKeyValue {
              mkKeyValue = lib.generators.mkKeyValueDefault {
                mkValueString =
                  v:
                  if builtins.isBool v then
                    (if v then "True" else "False")
                  else if builtins.isString v then
                    ''"${v}"''
                  else
                    toString v;
              } " = ";
            };
          in
          toKeyValue cfg.settings;
      };
    };
}
