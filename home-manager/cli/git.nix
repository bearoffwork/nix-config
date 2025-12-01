{pkgs, ...}: {
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

      includes = [
        {
          condition = "hasconfig:remote.origin.url:https://github.com/euimoney/*";
          contents.user.email = "bear@eui.money";
        }
      ];

      settings = {
        user.name = "Bear.Y";
        user.email = "codes@bearoff.wrok";

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
          cam = "commit -am";
          caa = "commit -a --amend";
          caam = "commit -a --amend -m";
          mr = "merge --no-ed";
          mrc = "merge --continue";
          rs = "reset";
          cp = "cherry-pick";
        };
      };
    };
  };
}
