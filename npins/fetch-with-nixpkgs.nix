{
  lib,
  fetchzip,
  fetchgit,
  sources ? ./sources.json,
  ...
}:
let
  data = lib.importJSON sources;

  # If the environment variable NPINS_OVERRIDE_${name} is set, then use
  # the path directly as opposed to the fetched source.
  # (Taken from Niv for compatibility)
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

  mkGitSource =
    {
      repository,
      revision,
      url ? null,
      submodules,
      hash,
      ...
    }:
    assert repository ? type;
    if url != null && !submodules then
      fetchzip {
        inherit url;
        sha256 = hash;
        extension = "tar.gz";
      }
    else
      # TODO: only tested once
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
        urlToName =
          url: rev:
          let
            matched = builtins.match "^.*/([^/]*)(\\.git)?$" url;

            short = builtins.substring 0 7 rev;

            appendShort = if (builtins.match "[a-f0-9]*" rev) != null then "-${short}" else "";
          in
          "${if matched == null then "source" else builtins.head matched}${appendShort}";
        name = urlToName url revision;
      in
      fetchgit {
        inherit name url;
        rev = revision;
        sha256 = hash;
        fetchSubmodules = submodules;
      };

  mkSource =
    name: spec:
    assert spec ? type;
    let
      path =
        if spec.type == "Git" then
          mkGitSource spec
        else if spec.type == "GitRelease" then
          mkGitSource spec
        # else if spec.type == "PyPi" then
        #   mkPyPiSource spec
        # else if spec.type == "Channel" then
        #   mkChannelSource spec
        # else if spec.type == "Tarball" then
        #   mkTarballSource spec
        else
          builtins.throw "Unknown source type ${spec.type}";
    in
    spec // { outPath = mayOverride name path; };
in
if data.version == 5 then
  lib.mapAttrs mkSource data.pins
else
  throw "npins: i have never seen this version in my entire life (${data.version})"
