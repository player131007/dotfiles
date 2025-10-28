{
  lib,
  config,
  my,
  ...
}:
let
  inherit (builtins) genList concatStringsSep length;
  inherit (my.lib) deconstructPath;
  inherit (lib.lists) take dropEnd;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (lib.types)
    bool
    lazyAttrsOf
    path
    pathWith
    listOf
    str
    attrTag
    coercedTo
    anything
    ;
  submodule = modules: lib.types.submoduleWith { modules = lib.toList modules; };

  outerConfig = config;

  targetOpts =
    {
      commonMountOptions,
      defaultOwner,
      config,
      ...
    }:
    {
      options = {
        inInitrd = mkOption {
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
              type = submodule {
                options = {
                  mountOptions = mkOption { type = listOf str; };
                  extraConfig = mkOption {
                    type = lazyAttrsOf anything;
                    default = { };
                  };
                };

                config.mountOptions = commonMountOptions;
              };
            };
          };

          default = {
            bindmount = { };
          };
        };

        intermediatePaths = mkOption {
          internal = true;
          visible = false;
          readOnly = true;
          type = listOf str;
        };

        prefix = mkOption {
          internal = true;
          visible = false;
          readOnly = true;
          type = path;
        };
      };

      config = {
        intermediatePaths =
          let
            components = dropEnd 1 (deconstructPath config.target).components;
          in
          genList (i: concatStringsSep "/" (take (i + 1) components)) (length components);
      };
    };

  targetType =
    {
      pathType,
      targetAlias,
      extraModules ? [ ],
      prefix ? "/",
    }:
    coercedTo pathType (target: { inherit target; }) (
      submodule (
        [
          targetOpts
          (mkAliasOptionModule targetAlias [ "target" ])
          {
            options.target = mkOption { type = pathType; };
            config = { inherit prefix; };
          }
        ]
        ++ extraModules
      )
    );

  atType = submodule (
    { name, config, ... }:
    let
      moduleArgs = defaultOwner: {
        _module.args = {
          inherit (config) commonMountOptions;
          inherit defaultOwner;
        };
      };

      inherit (outerConfig.users.users) root;

      userType = submodule (
        { name, ... }:
        let
          user = outerConfig.users.users.${name};
        in
        {
          options = {
            files = mkOption {
              type = listOf (targetType {
                pathType = pathWith { absolute = false; };
                targetAlias = [ "file" ];
                extraModules = [ (moduleArgs user) ];
                prefix = user.home;
              });

              default = [ ];
            };

            directories = mkOption {
              type = listOf (targetType {
                pathType = pathWith { absolute = false; };
                targetAlias = [ "directory" ];
                extraModules = [ (moduleArgs user) ];
                prefix = user.home;
              });

              default = [ ];
            };
          };
        }
      );

    in
    {
      options = {
        enable = mkOption {
          type = bool;
          default = true;
        };

        storagePath = mkOption {
          type = path;
          default = name;
        };

        commonMountOptions = mkOption {
          type = listOf str;
          default = [ "X-fstrim.notrim" ];
        };

        files = mkOption {
          type = listOf (targetType {
            pathType = path;
            targetAlias = [ "file" ];
            extraModules = [ (moduleArgs root) ];
          });

          default = [ ];
        };

        directories = mkOption {
          type = listOf (targetType {
            pathType = path;
            targetAlias = [ "directory" ];
            extraModules = [ (moduleArgs root) ];
          });

          default = [ ];
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
