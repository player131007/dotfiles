{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins)
    all
    attrValues
    concatMap
    filter
    length
    ;
  inherit (lib.lists) uniqueStrings;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.trivial) pipe;

  pLib = import ./lib.nix lib;

  isEmptyCfg =
    let
      check = cfg: length cfg.files + length cfg.directories == 0;
    in
    cfg: all check ([ cfg ] ++ attrValues cfg.users);

  lateCfg = pipe config.persist.at [
    attrValues
    (map (pLib.filterTargets (t: !t.early)))
    (filter (cfg: !isEmptyCfg cfg))
  ];

  earlyCfg = pipe config.persist.at [
    attrValues
    (map (pLib.filterTargets (t: t.early)))
    (filter (cfg: !isEmptyCfg cfg))
  ];

  mapCfgToList' =
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
      (mapCfgToList' pLib.mkBindMount)
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

      tmpfilesRules = mapCfgToList' pLib.mkTmpfilesRules;

      symlinks =
        cfg:
        pipe cfg [
          (pLib.filterTargets (t: t.method ? symlink))
          (mapCfgToList' pLib.mkSymlink)
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

    persist.tmpfilesSettings = {
      initrd = mkMerge (map handleTmpfiles earlyCfg);
      normal = mkMerge (map handleTmpfiles lateCfg);
    };

    boot.initrd.systemd =
      let
        ruleFile = pkgs.writeText "persistence.conf" (
          pLib.makeRuleFileContent config.persist.tmpfilesSettings.initrd
        );
      in
      {
        targets.persistence = {
          description = "Early Persistence Mounts";
          wantedBy = [ "initrd.target" ];
          before = [ "initrd.target" ];
        };

        storePaths = [ ruleFile ];

        services.systemd-tmpfiles-setup-persist = {
          after = [ "initrd-fs.target" ];
          requiredBy = [ "persistence.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "systemd-tmpfiles --create --remove --boot ${ruleFile}";
            SuccessExitStatus = [ "DATAERR CANTCREAT" ];
            ImportCredential = [
              "tmpfiles.*"
              "login.motd"
              "login.issue"
              "network.hosts"
              "ssh.authorized_keys.root"
            ];
            RestrictSUIDSGID = false;
          };
          unitConfig = {
            DefaultDependencies = false;
            RefuseManualStop = true;
            RequiresMountsFor = map (p: toString (/sysroot + "/${p}")) (
              uniqueStrings (map (cfg: cfg.storagePath) earlyCfg)
            );
          };
        };

        mounts = concatMap handleMounts earlyCfg;
      };

    systemd = {
      targets.persistence = {
        description = "Persistence Mounts";
        wantedBy = [ "sysinit.target" ];
        before = [ "sysinit.target" ];
      };

      services.systemd-tmpfiles-setup-persist = {
        after = [ "local-fs.target" ];
        requiredBy = [ "persistence.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart =
            let
              ruleFile = pkgs.writeText "persistence.conf" (
                pLib.makeRuleFileContent config.persist.tmpfilesSettings.normal
              );
            in
            "systemd-tmpfiles --create --remove --boot ${ruleFile}";
          SuccessExitStatus = [ "DATAERR CANTCREAT" ];
          ImportCredential = [
            "tmpfiles.*"
            "login.motd"
            "login.issue"
            "network.hosts"
            "ssh.authorized_keys.root"
          ];
          RestrictSUIDSGID = false;
        };
        unitConfig = {
          DefaultDependencies = false;
          RefuseManualStop = true;
          RequiresMountsFor = uniqueStrings (map (cfg: cfg.storagePath) lateCfg);
        };
      };

      mounts =
        let
          handleLateOverrides =
            cfg:
            pipe cfg [
              (pLib.filterTargets (t: t.method ? bindmount))
              (mapCfgToList' (
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
