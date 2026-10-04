{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    git
    gh
    tig
    delta
  ];

  # Aliases git to g
  home.shellAliases = {
    g = "git";
  };

  programs = {
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    git = {
      enable = true;
      settings = {
        user.name = "Bear.Y";
        user.email = "bear@eui.money";

        core = {
          fsmonitor = true;
          untrackedcache = true;
          preloadindex = true;
        };

        protocol = {
          version = 2;
        };

        fetch = {
          parallel = 8;
        };

        maintenance = {
          auto = true;
          strategy = "incremental";
          repo = [ "${config.home.srcDirectory}/o/nixpkgs" ];
        };

        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autoStash = true;
        merge.ff = false;
        rerere.enabled = true;
        # disable mac keychain to fix gh randomly unauthorized issue.
        credential.helper = "";
        branch.sort = "committerdate";
        alias = {
          sw = "show";
          st = "status";
          ch = "checkout";
          pu = "push";
          pl = "pull";
          aa = "add -A";

          cm = "commit -m";
          ca = "commit --amend";
          cam = "commit -am";
          caa = "commit -a --amend";
          caam = "commit -a --amend -m";

          mr = "merge --no-ed";
          mrc = "merge --continue";

          rs = "reset";
          rsh = "reset --hard";

          cp = "cherry-pick";
        };
      };
    };
  };
}
