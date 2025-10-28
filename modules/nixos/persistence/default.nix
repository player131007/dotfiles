{
  config,
  lib,
  my,
  ...
}:
let
  inherit (builtins)
    filter
    mapAttrs
    attrValues
    concatMap
    replaceStrings
    concatStringsSep
    ;
  inherit (my.lib) concatPaths;
  inherit (lib.lists) concatLists singleton optional;
  inherit (lib.trivial) pipe;
  inherit (lib.modules) mkMerge mkIf mkDefault;

  isDirectory = target: target ? directory;
  isSymlink = target: target.method ? symlink;
  isBindMount = target: target.method ? bindmount;

  getTargets =
    { inInitrd, cfg }:
    let
      inherit (cfg) files directories;
    in
    filter (t: t.inInitrd == inInitrd) (files ++ directories);

  getAllTargets =
    { inInitrd, cfg }:
    let
      normalTargets = getTargets { inherit inInitrd cfg; };
      userTargets = map (cfg: (getTargets { inherit inInitrd cfg; })) (builtins.attrValues cfg.users);
    in
    normalTargets ++ concatLists userTargets;

  mkPersist =
    { inInitrd }:
    let
      prefix = if inInitrd then "/sysroot" else "/";

      mkStuff =
        handleTarget:
        pipe config.persist.at [
          attrValues
          (concatMap (
            cfg:
            map (handleTarget cfg.storagePath) (getAllTargets {
              inherit inInitrd cfg;
            })
          ))
          mkMerge
        ];

      mkTargetPaths =
        storagePath: target:
        let
          mkPath =
            extra: isStoragePath:
            concatPaths (concatLists [
              [ prefix ]
              (optional isStoragePath storagePath)
              [
                target.prefix
                extra
              ]
            ]);

          sth = {
            source = true;
            dest = false;
          };
        in
        {
          real = mapAttrs (_: mkPath target.target) sth;
          intermediate = map (path: mapAttrs (_: mkPath path) sth) target.intermediatePaths;
        };
    in
    {
      mounts = mkStuff (
        storagePath: target:
        let
          path = (mkTargetPaths storagePath target).real;
          targetUnit = if inInitrd then "persistence-initrd.target" else "persistence.target";
        in
        optional (isBindMount target) (mkMerge [
          {
            what = path.source;
            where = path.dest;
            options = pipe target.method.bindmount.mountOptions [
              (
                opts:
                concatLists [
                  [ "bind" ]
                  (optional inInitrd "x-initrd.mount")
                  opts
                ]
              )
              (map (replaceStrings [ "%" ] [ "%%" ]))
              (concatStringsSep ",")
            ];

            unitConfig.DefaultDependencies = false;
            conflicts = [ "umount.target" ];
            wantedBy = [ targetUnit ];
            before = [
              targetUnit
              "umount.target"
            ];
          }
          {
            # i heard putting directory mounts after tmpfiles creates dependency hell
            # since systemd mounts can create directories for you, just put directories before tmpfiles
            # and it can change directory permissions later
            # source file needs to exist for systemd to mount, so put files after tmpfiles
            ${if (isDirectory target) then "before" else "after"} =
              if inInitrd then
                [ "systemd-tmpfiles-setup-sysroot.service" ]
              else
                [ "systemd-tmpfiles-setup.service" ];
          }
          target.method.bindmount.extraConfig
        ])
      );
      tmpfiles.settings.persistence = mkStuff (
        storagePath: target:
        let
          tmpfiles-type = if isDirectory target then "d" else "f";

          paths = mkTargetPaths storagePath target;
        in
        mkMerge (
          [
            # destination perms will be the same as source
            (mkIf (target.method.symlink.createLinkTarget or true) {
              ${paths.real.source}.${tmpfiles-type} = {
                user = target.owner;
                inherit (target) group mode;
              };
            })

            (mkIf (isSymlink target) {
              ${paths.real.dest}.L.argument = concatPaths [
                storagePath
                target.prefix
                target.target
              ];
            })
          ]
          ++ map (
            path:
            let
              value = {
                d = mapAttrs (_: mkDefault) {
                  user = if prefix == "/" then "root" else target.owner;
                  group = if prefix == "/" then "root" else target.group;
                  mode = "-";
                };
              };
            in
            {
              ${path.dest} = value;
              ${path.source} = value;
            }
          ) paths.intermediate

        )
      );
    };
in
{
  imports = [ ./options.nix ];

  config = mkIf config.persist.enable {
    assertions = singleton {
      assertion = config.boot.initrd.systemd.enable;
      message = "persistence module only works with systemd-based initrd";
    };

    boot.initrd.systemd = mkMerge [
      (mkPersist { inInitrd = true; })
      {
        targets.persistence-initrd = {
          description = "Initrd Persistence Mounts";
          wantedBy = [ "initrd.target" ];
          before = [ "initrd.target" ];
        };
      }
    ];
    systemd = mkMerge [
      (mkPersist { inInitrd = false; })
      {
        targets.persistence = {
          description = "Persistence Mounts";
          wantedBy = [ "sysinit.target" ];
          before = [ "sysinit.target" ];
        };
      }
    ];
  };
}
