{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git
    gh
  ];

  programs = {
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    git = {
      enable = true;
      userName = "Bear.Y";
      userEmail = "codes@rra3b.io";

      aliases = {
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
        rst = "reset";
      };

      includes = [
        {
          condition = "hasconfig:remote.origin.url:https://github.com/euimoney/*";
          contents.user.email = "bear@eui.money";
        }
      ];
    };
  };
}
