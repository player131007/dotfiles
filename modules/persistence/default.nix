{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins)
    attrValues
    concatMap
    filter
    mapAttrs
    ;
  inherit (lib.lists) uniqueStrings;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.strings) concatStrings;

  pLib = import ./lib.nix lib;

  lateCfg =
    config.persist.at
    |> attrValues
    |> map (pLib.filterTargets (t: !t.early))
    |> filter (cfg: !pLib.isEmpty cfg);

  earlyCfg =
    config.persist.at
    |> attrValues
    |> map (pLib.filterTargets (t: t.early))
    |> filter (cfg: !pLib.isEmpty cfg);

  cfgToList' =
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
    f: pLib.cfgToList f (wrap f);

  handleMounts =
    cfg: cfg |> pLib.filterTargets (t: t.method ? bindmount) |> cfgToList' pLib.mkBindMount;

  handleTmpfiles =
    cfg:
    let
      intermediateRules =
        pLib.cfgToList
          (
            storagePath: target:
            pLib.mkIntermediateDirRules {
              defaultOwner = config.users.users.root;
              root = "/";
              inherit storagePath target;
            }
          )
          (
            storagePath: user: target:
            pLib.mkIntermediateDirRules {
              defaultOwner = config.users.users.${user};
              root = config.users.users.${user}.home;
              inherit storagePath target;
            }
          );

      tmpfilesRules = cfgToList' pLib.mkTmpfilesRules;

      symlinks = cfg: cfg |> pLib.filterTargets (t: t.method ? symlink) |> cfgToList' pLib.mkSymlink;
    in
    mkMerge (
      concatMap (f: f cfg) [
        intermediateRules
        symlinks
        tmpfilesRules
      ]
    );

  makeRuleFileContent =
    let
      escapeArgument = lib.strings.escapeC [
        "\t"
        "\n"
        "\r"
        " "
        "\\"
      ];

      settingsEntryToRule = path_: entry: ''
        '${entry.type}' '${path_}' '${entry.mode}' '${entry.user}' '${entry.group}' '${entry.age}' ${escapeArgument entry.argument}
      '';
    in
    paths:
    paths
    |> mapAttrs (
      path_: attrs:
      attrs
      |> mapAttrs (_type: settingsEntryToRule path_)
      |> attrValues
      |> concatStrings
    )
    |> attrValues
    |> concatStrings;

  tmpfilesService = {
    requiredBy = [ "persistence.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
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
    };
  };
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
          makeRuleFileContent config.persist.tmpfilesSettings.initrd
        );
      in
      {
        targets.persistence = {
          description = "Early Persistence Mounts";
          wantedBy = [ "initrd.target" ];
          before = [ "initrd.target" ];
        };

        storePaths = [ ruleFile ];

        services.systemd-tmpfiles-setup-persist = mkMerge [
          tmpfilesService
          {
            after = [ "initrd-fs.target" ];
            serviceConfig.ExecStart = "systemd-tmpfiles --create --remove --boot ${ruleFile}";
            unitConfig.RequiresMountsFor =
              earlyCfg |> map (cfg: toString (/sysroot + cfg.storagePath)) |> uniqueStrings;
          }
        ];

        mounts = concatMap handleMounts earlyCfg;
      };

    systemd = {
      targets.persistence = {
        description = "Persistence Mounts";
        wantedBy = [ "sysinit.target" ];
        before = [ "sysinit.target" ];
      };

      services.systemd-tmpfiles-setup-persist =
        let
          ruleFile = pkgs.writeText "persistence.conf" (
            makeRuleFileContent config.persist.tmpfilesSettings.normal
          );
        in
        mkMerge [
          tmpfilesService
          {
            after = [ "local-fs.target" ];
            serviceConfig.ExecStart = "systemd-tmpfiles --create --remove --boot ${ruleFile}";
            unitConfig.RequiresMountsFor = lateCfg |> map (cfg: cfg.storagePath) |> uniqueStrings;
          }
        ];

      mounts =
        let
          addLateDropins =
            cfg:
            cfg
            |> pLib.filterTargets (t: t.method ? bindmount)
            |> cfgToList' (
              storagePath: target:
              mkMerge [
                (pLib.mkBindMount storagePath (target // { early = false; }))
                { overrideStrategy = "asDropin"; }
              ]
            );
        in
        concatMap handleMounts lateCfg ++ concatMap addLateDropins earlyCfg;
    };
  };
}
