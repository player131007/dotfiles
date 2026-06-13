{ config, lib, ... }:
let
  inherit (lib) types;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkBefore mkMerge;
  inherit (lib.options) mkOption;

  targetsModule =
    {
      relative,
      commonMountOptions,
      defaultOwner,
    }:
    let
      pathType = types.pathWith {
        absolute = !relative;
        inStore = false;
      };

      targetModule =
        { config, ... }:
        {
          config.tmpfilesSettings = optionalAttrs (config.method.symlink.createLinkTarget or true) {
            ${if config ? file then "f" else "d"} = {
              user = config.owner;
              inherit (config) group mode;
            };
          };

          options = {
            early = mkOption {
              type = types.bool;
              default = false;
            };

            owner = mkOption {
              type = types.str;
              default = defaultOwner.name;
            };
            group = mkOption {
              type = types.str;
              default = defaultOwner.group;
            };
            mode = mkOption {
              type = types.str;
              default = "-";
            };

            method = mkOption {
              default = {
                bindmount = { };
              };

              type = types.attrTag {
                symlink = mkOption {
                  type = types.submodule {
                    options.createLinkTarget = mkOption {
                      type = types.bool;
                      default = false;
                    };
                  };
                };

                bindmount = mkOption {
                  type = types.submodule (
                    { config, ... }:
                    {
                      options = {
                        mountOptions = mkOption { type = types.listOf types.str; };
                        extraConfig = mkOption { type = types.deferredModule; };
                      };

                      config = {
                        mountOptions = mkBefore commonMountOptions;
                        extraConfig.config.options = mkMerge config.mountOptions;
                      };
                    }
                  );
                };
              };
            };

            tmpfilesSettings = mkOption {
              type = types.lazyAttrsOf types.deferredModule;

              # apply here instead of in `lib.nix` because tmpfiles expects attrsets of submodules
              apply = builtins.mapAttrs (
                _: module:
                { ... }:
                {
                  imports = [ module ];
                }
              );
            };
          };
        };

      target =
        targetType:
        types.coercedTo pathType (target: { ${targetType} = target; }) (
          types.submodule [
            { options.${targetType} = mkOption { type = pathType; }; }
            targetModule
          ]
        );
    in
    {
      options = {
        files = mkOption {
          type = types.listOf (target "file");
          default = [ ];
        };

        directories = mkOption {
          type = types.listOf (target "directory");
          default = [ ];
        };
      };
    };
in
{
  options.persist = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    at = mkOption {
      type =
        let
          inherit (config.users) users;
        in
        types.lazyAttrsOf (
          types.submodule (
            { config, name, ... }:
            {
              imports = singleton (targetsModule {
                relative = false;
                inherit (config) commonMountOptions;
                defaultOwner = users.root;
              });
              options = {
                enable = mkOption {
                  type = types.bool;
                  default = true;
                };

                storagePath = mkOption {
                  type = types.externalPath;
                  default = name;
                };

                commonMountOptions = mkOption {
                  type = types.listOf types.str;
                  default = [
                    "x-gvfs-hide"
                    "x-gdu.hide"
                    "X-fstrim.notrim"
                  ];
                };

                users = mkOption {
                  type = types.lazyAttrsOf (
                    types.submodule (
                      { name, ... }:
                      {
                        imports = singleton (targetsModule {
                          relative = true;
                          inherit (config) commonMountOptions;
                          defaultOwner = users.${name};
                        });
                      }
                    )
                  );
                  default = { };
                };
              };
            }
          )
        );
    };
  };
}
