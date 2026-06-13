{ config, lib, ... }:
let
  inherit (builtins) attrValues concatMap;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.trivial) pipe;

  pLib = import ./lib.nix lib;

  lateCfg = pipe config.persist.at [
    attrValues
    (map (pLib.filterTargets (t: !t.early)))
  ];

  earlyCfg = pipe config.persist.at [
    attrValues
    (map (pLib.filterTargets (t: t.early)))
  ];

  mapCfgToList =
    let
      wrap =
        f: storagePath: user: target:
        f storagePath (
          target
          // {
            ${if target ? file then "file" else "directory"} = pLib.concatPaths [
              config.users.users.${user}.home
              (pLib.getPath target)
            ];
          }
        );
    in
    f: pLib.mapCfgToList f (wrap f);

  handleMounts =
    cfg:
    pipe cfg [
      (pLib.filterTargets (t: t.method ? bindmount))
      (mapCfgToList pLib.mkBindMount)
    ];

  handleTmpfiles =
    cfg:
    let
      intermediateRules =
        pLib.mapCfgToList
          (
            storagePath: target:
            pLib.mkIntermediateDirRules {
              defaultOwner = config.users.users.root;
              prefix = "/";
              inherit storagePath target;
            }
          )
          (
            storagePath: user: target:
            pLib.mkIntermediateDirRules {
              defaultOwner = config.users.users.${user};
              prefix = config.users.users.${user}.home;
              inherit storagePath target;
            }
          );

      tmpfilesRules = mapCfgToList pLib.mkTmpfilesRules;

      symlinks =
        cfg:
        pipe cfg [
          (pLib.filterTargets (t: t.method ? symlink))
          (mapCfgToList pLib.mkSymlink)
        ];
    in
    mkMerge (
      concatMap (f: f cfg) [
        intermediateRules
        symlinks
        tmpfilesRules
      ]
    );
in
{
  imports = [ ./options.nix ];

  config = mkIf config.persist.enable {
    assertions = lib.lists.singleton {
      assertion = config.boot.initrd.systemd.enable;
      message = "persistence module only works with systemd-based initrd";
    };

    boot.initrd.systemd = {
      targets.persistence = {
        description = "Early Persistence Mounts";
        requires = [ "systemd-tmpfiles-setup-sysroot.service" ];
        wantedBy = [ "initrd.target" ];
        before = [ "initrd.target" ];
      };

      tmpfiles.settings.persistence = mkMerge (map handleTmpfiles earlyCfg);

      mounts = concatMap handleMounts earlyCfg;
    };

    systemd = {
      targets.persistence = {
        description = "Persistence Mounts";
        requires = [ "systemd-tmpfiles-setup.service" ];
        wantedBy = [ "sysinit.target" ];
        before = [ "sysinit.target" ];
      };

      tmpfiles.settings.persistence = mkMerge (map handleTmpfiles lateCfg);

      mounts =
        let
          handleLateOverrides =
            cfg:
            pipe cfg [
              (pLib.filterTargets (t: t.method ? bindmount))
              (mapCfgToList (
                storagePath: target:
                mkMerge [
                  (pLib.mkBindMount storagePath (target // { early = false; }))
                  { overrideStrategy = "asDropin"; }
                ]
              ))
            ];
        in
        concatMap handleMounts lateCfg ++ concatMap handleLateOverrides earlyCfg;
    };
  };
}
