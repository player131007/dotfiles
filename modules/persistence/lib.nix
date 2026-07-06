lib:
let
  inherit (builtins)
    concatLists
    concatStringsSep
    filter
    genList
    length
    mapAttrs
    ;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) dropEnd take;
  inherit (lib.modules) mkDefault mkIf mkMerge;
  inherit (lib.strings) concatStrings optionalString;
  inherit (lib.trivial) pipe;

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
    concatStrings (
      mapAttrsToList (
        path_: types: concatStrings (mapAttrsToList (_: settingsEntryToRule path_) types)
      ) paths
    );

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
      prefix,
      storagePath,
      target,
    }:
    let
      components = pipe target [
        getPath
        (p: (deconstructPath p).components)
        (dropEnd 1)
      ];

      value.d = mapAttrs (_: mkDefault) {
        user = defaultOwner.name;
        group = defaultOwner.group;
      };
    in
    mkMerge (
      genList (
        i:
        let
          c = take (i + 1) components;

          persistPath = concatPaths (
            [
              (maybeSysroot target)
              storagePath
              prefix
            ]
            ++ c
          );

          realPath = concatPaths (
            [
              (maybeSysroot target)
              prefix
            ]
            ++ c
          );
        in
        {
          ${persistPath} = value;
          ${realPath} = value;
        }
      ) (length components)
    );

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

  mapCfgToList =
    f_abs: f_user: cfg:
    map (f_abs cfg.storagePath) (cfg.files ++ cfg.directories)
    ++ pipe cfg.users [
      (mapAttrsToList (user: cfg': map (f_user cfg.storagePath user) (cfg'.files ++ cfg'.directories)))
      concatLists
    ];
}
