{
  config,
  lib,
  myLib,
  ...
}:
let
  inherit (builtins)
    filter
    getAttr
    partition
    mapAttrs
    attrValues
    concatMap
    concatStringsSep
    genList
    length
    ;
  inherit (lib.lists)
    optional
    singleton
    take
    dropEnd
    ;
  inherit (myLib) concatPaths deconstructPath;
  inherit (lib.strings) optionalString;
  inherit (lib.trivial) pipe;
  inherit (lib.modules) mkMerge mkIf mkDefault;

  isDirectory = target: target ? directory;
  isSymlink = target: target.method ? symlink;
  isBindMount = target: target.method ? bindmount;

  getPath = target: target.file or target.directory;

  mkTargetPaths =
    forInitrd: target:
    let
      mkPath =
        extra: isStoragePath:
        concatPaths [
          (optionalString forInitrd "/sysroot")
          (optionalString isStoragePath target.storagePath)
          target.prefix
          extra
        ];

      mkPaths = extra: {
        source = mkPath extra true;
        dest = mkPath extra false;
      };

      components = pipe target [
        getPath
        (p: (deconstructPath p).components)
        (dropEnd 1)
      ];
      intermediatePaths = genList (i: concatStringsSep "/" (take (i + 1) components)) (length components);
    in
    {
      real = mkPaths (getPath target);
      intermediate = map mkPaths intermediatePaths;
    };

  mkMount =
    forInitrd: target:
    assert isBindMount target;
    let
      path = (mkTargetPaths forInitrd target).real;
    in
    lib.mkMerge [
      {
        what = path.source;
        where = path.dest;
        options = concatStringsSep "," (target.method.bindmount.mountOptions ++ [ "bind" ]);

        unitConfig.DefaultDependencies = false;
        conflicts = [ "umount.target" ];
        requiredBy = [ "persistence.target" ];
        before = [
          "persistence.target"
          "umount.target"
        ];
      }
      {
        # directories can be created when mounting so we put it before tmpfiles
        # i heard this avoids dependency hell
        # source file needs to exist for systemd to mount, so put files after tmpfiles
        ${if isDirectory target then "before" else "after"} =
          if forInitrd then
            [ "systemd-tmpfiles-setup-sysroot.service" ]
          else
            [ "systemd-tmpfiles-setup.service" ];
      }
      target.method.bindmount.extraConfig
    ];

  mkSymlink =
    forInitrd: target:
    assert isSymlink target;
    let
      inherit ((mkTargetPaths forInitrd target).real) dest;
      inherit ((mkTargetPaths false target).real) source;
    in
    {
      # because the symlink is for stage 2 and not initrd
      # we symlink it to the real source
      ${dest}.L.argument = source;
    };

  mkTmpfilesRules =
    forInitrd: target:
    let
      tmpfiles-type = if isDirectory target then "d" else "f";
      paths = mkTargetPaths forInitrd target;
    in
    mkMerge (
      map (
        path:
        let
          value.d = mapAttrs (_: mkDefault) {
            user = if target.prefix == "/" then "root" else target.owner;
            group = if target.prefix == "/" then "root" else target.group;
          };
        in
        {
          ${path.dest} = value;
          ${path.source} = value;
        }
      ) paths.intermediate
      ++ optional (target.method.symlink.createLinkTarget or true) {
        ${paths.real.source}.${tmpfiles-type} = {
          user = target.owner;
          inherit (target) group mode;
        };
      }
    );

  getTargetsInPath =
    cfg:
    concatMap (c: map (t: t // { inherit (cfg) storagePath; }) (c.files ++ c.directories)) (
      attrValues cfg.users ++ [ cfg ]
    );

  allTargets = pipe config.persist.at [
    attrValues
    (concatMap getTargetsInPath)
    (partition (t: t.inInitrd))
  ];

  mkPersist =
    forInitrd:
    let
      targets = getAttr (if forInitrd then "right" else "wrong") allTargets;
    in
    {
      mounts = pipe targets [
        (filter isBindMount)
        (map (mkMount forInitrd))
      ];

      tmpfiles.settings.persistence = mkMerge (
        map (mkTmpfilesRules forInitrd) targets
        ++ pipe targets [
          (filter isSymlink)
          (map (mkSymlink forInitrd))
        ]
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
      {
        targets.persistence = {
          description = "Initrd Persistence Mounts";
          wantedBy = [ "initrd.target" ];
          before = [ "initrd.target" ];
        };
      }
      (mkPersist true)
    ];

    systemd = mkMerge [
      {
        targets.persistence = {
          description = "Persistence Mounts";
          wantedBy = [ "sysinit.target" ];
          before = [ "sysinit.target" ];
        };
      }
      (mkPersist false)
    ];
  };
}
