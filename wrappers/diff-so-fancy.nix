_adios: {
  inputs = {
    less.from = { parent }: parent.less;
  };

  mutations."/git".settings =
    { inputs }:
    let
      inherit (inputs.nixpkgs) lib;
      less = inputs.less { };
    in
    {
      # use `diff-so-fancy` from PATH to avoid dependency cycle
      # git-config -> diff-so-fancy -> gitWrapped -> git-config
      interactive.diffFilter = "diff-so-fancy --patch";
      core.pager = "diff-so-fancy | ${lib.getExe less}";

      diff-so-fancy.markEmptyLines = false;
    };
}
