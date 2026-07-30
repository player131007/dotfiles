lib:
let
  inherit (builtins)
    all
    attrValues
    concatLists
    concatStringsSep
    filter
    genList
    length
    mapAttrs
    ;
  inherit (lib.lists) dropEnd take;
  inherit (lib.modules) mkDefault mkIf mkMerge;
  inherit (lib.strings) optionalString;

  concatPaths =
    components:
    let
      subpath = if components == [ ] then "." else concatStringsSep "/" components;
    in
    toString (/. + subpath);

  deconstructPath =
    let
      recurse =
        components: base:
        # If the parent of a path is the path itself, then it's a filesystem root
        if base == dirOf base then
          {
            root = base;
            inherit components;
          }
        else
          recurse ([ (baseNameOf base) ] ++ components) (dirOf base);
    in
    recurse [ ];

  getPath = target: target.file or target.directory;
  maybeSysroot = target: optionalString target.early "/sysroot";
in
{
  inherit concatPaths getPath;

  mkBindMount =
    storagePath: target:
    assert target.method ? bindmount;
    # is a function to circumvent shorthandOnlyDefinesConfig limitation
    { ... }:
    {
      imports = [
        target.method.bindmount.extraConfig
        {
          # directories can be created when mounting so we put it before tmpfiles
          # i heard this avoids dependency hell
          # source file needs to exist for systemd to mount, so put files after tmpfiles
          ${if target ? directory then "before" else "after"} = [ "systemd-tmpfiles-setup-persist.service" ];
        }
      ];

      config = {
        what = concatPaths [
          (maybeSysroot target)
          storagePath
          (getPath target)
        ];
        where = concatPaths [
          (maybeSysroot target)
          (getPath target)
        ];

        options = "bind";
        unitConfig.DefaultDependencies = false;
        conflicts = [ "umount.target" ];
        requiredBy = [ "persistence.target" ];
        before = [
          "persistence.target"
          "umount.target"
        ];
      };
    };

  mkSymlink =
    storagePath: target:
    assert target.method ? symlink;
    {
      # link target doesn't have `/sysroot`
      # because the symlink is for stage 2
      ${
        concatPaths [
          (maybeSysroot target)
          (getPath target)
        ]
      }.L.argument =
        concatPaths [
          storagePath
          (getPath target)
        ];
    };

  mkTmpfilesRules =
    storagePath: target:
    mkIf (target.tmpfilesSettings != { }) {
      ${
        concatPaths [
          (maybeSysroot target)
          storagePath
          (getPath target)
        ]
      } =
        target.tmpfilesSettings;
    };

  mkIntermediateDirRules =
    {
      defaultOwner,
      root,
      storagePath,
      target,
    }:
    let
      components =
        target
        |> getPath
        |> (p: (deconstructPath p).components)
        |> dropEnd 1;

      value.d = mapAttrs (_: mkDefault) {
        user = defaultOwner.name;
        group = defaultOwner.group;
      };
    in
    length components
    |> genList (
      i:
      let
        c = take (i + 1) components;

        persistPath = concatPaths (
          [
            (maybeSysroot target)
            storagePath
            root
          ]
          ++ c
        );

        realPath = concatPaths (
          [
            (maybeSysroot target)
            root
          ]
          ++ c
        );
      in
      {
        ${persistPath} = value;
        ${realPath} = value;
      }
    )
    |> mkMerge;

  filterTargets =
    pred: cfg:
    let
      filterCfg =
        cfg:
        cfg
        // {
          files = filter pred cfg.files;
          directories = filter pred cfg.directories;
        };
    in
    filterCfg cfg // { users = mapAttrs (_: filterCfg) cfg.users; };

  isEmpty =
    cfg:
    let
      check = cfg: length cfg.files == 0 && length cfg.directories == 0;
    in
    check cfg && all check (attrValues cfg.users);

  cfgToList =
    f_abs: f_user: cfg:
    map (f_abs cfg.storagePath) (cfg.files ++ cfg.directories)
    ++ (
      cfg.users
      |> mapAttrs (user: cfg': map (f_user cfg.storagePath user) (cfg'.files ++ cfg'.directories))
      |> attrValues
      |> concatLists
    );
}
