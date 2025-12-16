# TODO: remove when new npins release

pkgs:
let
  inherit (pkgs) lib;

  data = lib.importJSON ./sources.json;
  version = data.version;

  mayOverride =
    name: path:
    let
      envVarName = "NPINS_OVERRIDE_${saneName}";
      saneName = lib.stringAsChars (c: if (builtins.match "[a-zA-Z0-9]" c) == null then "_" else c) name;
      ersatz = builtins.getEnv envVarName;
    in
    if ersatz == "" then
      path
    else
      # this turns the string into an actual Nix path (for both absolute and
      # relative paths)
      builtins.trace "Overriding path of \"${name}\" with \"${ersatz}\" due to set \"${envVarName}\"" (
        if builtins.substring 0 1 ersatz == "/" then
          /. + ersatz
        else
          /. + builtins.getEnv "PWD" + "/${ersatz}"
      );

  mkSource =
    name: spec:
    assert spec ? type;
    let
      func =
        {
          Git = mkGitSource;
          GitRelease = mkGitSource;
          PyPi = fetchurl;
          Channel = fetchzip;
          Tarball = fetchzip;
        }
        .${spec.type} or (throw "Unknown source type ${spec.type}");
    in
    spec
    // {
      vimPlugin = true;
      outPath = mayOverride name (func (lib.strings.sanitizeDerivationName name) spec);
    };

  fetchzip =
    pname:
    {
      url,
      locked_url ? url, # for compatibility with tarball fetching
      hash,
      version ? "0",
      ...
    }:
    pkgs.fetchzip {
      inherit pname version;
      url = locked_url;
      sha256 = hash;
    };

  fetchurl =
    pname:
    {
      url,
      hash,
      version ? "0",
      ...
    }:
    pkgs.fetchurl {
      inherit url pname version;
      sha256 = hash;
    };

  mkGitSource =
    pname:
    {
      repository,
      revision,
      url ? null,
      submodules,
      hash,
      ...
    }:
    assert repository ? type;
    let
      version = "0-unstable-${lib.sources.shortRev revision}";
    in
    if url != null && !submodules then
      fetchzip pname {
        inherit url hash version;
      }
    else
      let
        url =
          if repository.type == "Git" then
            repository.url
          else if repository.type == "GitHub" then
            "https://github.com/${repository.owner}/${repository.repo}.git"
          else if repository.type == "GitLab" then
            "${repository.server}/${repository.repo_path}.git"
          else
            throw "Unrecognized repository type ${repository.type}";
      in
      pkgs.fetchgit {
        inherit url pname version;
        fetchSubmodules = submodules;
        rev = revision;
      };
in
if version == 5 then
  builtins.mapAttrs mkSource data.pins
else
  throw "Unsupported format version ${toString version} in sources.json. Try running `npins upgrade`"
