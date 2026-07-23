{
  lib,
  myPkgs,
  pkgs,
  wrappers,
  ...
}:
{
  programs.less.enable = lib.mkForce false;
  environment.systemPackages = [
    wrappers.less
  ];

  my.user = {
    shell = wrappers.bash;
    packages = builtins.attrValues {
      inherit (pkgs)
        npins
        calc
        ripgrep
        xdg-utils
        _7zz-rar
        keepassxc
        mpv-unwrapped
        ;

      inherit (wrappers)
        bash
        obs
        git
        diff-so-fancy # here to avoid infrec
        starship
        carapace
        ;

      inherit (myPkgs) neovim;
    };
  };

  my.tmpfiles =
    let
      escapeArgument = lib.strings.escapeC [
        "\t"
        "\n"
        "\r"
        " "
        "\\"
      ];

      profile = /* bash */ ''
        export EDITOR=nvim
      '';
    in
    [
      "f+ %h/.profile 0600 - - - ${escapeArgument profile}"
    ];

  programs.ssh.knownHostsFiles = lib.singleton (
    builtins.toFile "github_keys" ''
      github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
      github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
      github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
    ''
  );
}
