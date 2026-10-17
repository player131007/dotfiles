{ promise, ... }: {
  inputs = {
    less.from = { parent }: parent.less;
  };

  mutations."/git".settings = promise (
    { inputs, results }:
    let
      inherit (inputs.nixpkgs) lib;
    in
    {
      # use `diff-so-fancy` from PATH to avoid dependency cycle
      # git-config -> diff-so-fancy -> gitWrapped -> git-config
      interactive.diffFilter = "diff-so-fancy --patch";
      core.pager = "diff-so-fancy | ${lib.getExe results.less}";

      diff-so-fancy.markEmptyLines = false;
    }
  );
}
