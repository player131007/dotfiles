{
  lib,
  config,
  ...
}:
let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkMerge;
  inherit (lib.types)
    bool
    lazyAttrsOf
    externalPath
    pathWith
    listOf
    str
    attrTag
    coercedTo
    deferredModule
    submodule
    ;

  targetOpts =
    {
      commonMountOptions,
      defaultOwner,
      config,
      ...
    }:
    {
      options = {
        early = mkOption {
          type = bool;
          default = false;
        };

        owner = mkOption {
          type = str;
          default = defaultOwner.name;
        };
        group = mkOption {
          type = str;
          default = defaultOwner.group;
        };
        mode = mkOption {
          type = str;
          default = "-";
        };

        tmpfilesSettings = mkOption {
          type = lazyAttrsOf deferredModule;
          apply = builtins.mapAttrs (
            _: cfg:
            { ... }:
            {
              imports = [ cfg ];
            }
          );
        };

        method = mkOption {
          type = attrTag {
            symlink = mkOption {
              type = submodule {
                options.createLinkTarget = mkOption {
                  type = bool;
                  default = false;
                };
              };
            };

            bindmount = mkOption {
              type = submodule (
                { config, ... }:
                {
                  options = {
                    mountOptions = mkOption { type = listOf str; };
                    extraConfig = mkOption { type = deferredModule; };
                  };

                  config = {
                    extraConfig.config.options = mkMerge config.mountOptions;
                    mountOptions = lib.mkBefore commonMountOptions;
                  };
                }
              );
            };
          };

          default = {
            bindmount = { };
          };
        };

        prefix = mkOption {
          internal = true;
          visible = false;
          readOnly = true;
          type = externalPath;
        };
      };

      config.tmpfilesSettings = optionalAttrs (config.method.symlink.createLinkTarget or true) {
        ${if config ? file then "f" else "d"} = {
          user = config.owner;
          inherit (config) group mode;
        };
      };
    };

  target =
    {
      prefix ? "/",
      relativePath ? false,
      defaultOwner,
      commonMountOptions,
      targetType,
    }:
    let
      pathType = pathWith {
        absolute = !relativePath;
        inStore = false;
      };
    in
    coercedTo pathType (target: { ${targetType} = target; }) (submodule [
      targetOpts
      {
        options.${targetType} = mkOption { type = pathType; };
        config = {
          inherit prefix;
          _module.args = { inherit commonMountOptions defaultOwner; };
        };
      }
    ]);

  mkTargetOptions = targetArgs: {
    files = mkOption {
      type = listOf (target (targetArgs // { targetType = "file"; }));
      default = [ ];
    };

    directories = mkOption {
      type = listOf (target (targetArgs // { targetType = "directory"; }));
      default = [ ];
    };
  };

  atType = submodule (
    { name, ... }@inner:
    let
      userType = submodule (
        { name, ... }:
        let
          user = config.users.users.${name};
        in
        {
          options = mkTargetOptions {
            defaultOwner = user;
            prefix = user.home;
            relativePath = true;
            inherit (inner.config) commonMountOptions;
          };
        }
      );
    in
    {
      options =
        mkTargetOptions {
          defaultOwner = config.users.users.root;
          inherit (inner.config) commonMountOptions;
        }
        // {
          enable = mkOption {
            type = bool;
            default = true;
          };

          storagePath = mkOption {
            type = externalPath;
            default = name;
          };

          commonMountOptions = mkOption {
            type = listOf str;
            default = [ "X-fstrim.notrim" ];
          };

          users = mkOption {
            type = lazyAttrsOf userType;
            default = { };
          };
        };
    }
  );
in
{
  options.persist = {
    enable = mkOption {
      type = bool;
      default = true;
    };

    at = mkOption {
      type = lazyAttrsOf atType;
      default = { };
    };
  };
}
