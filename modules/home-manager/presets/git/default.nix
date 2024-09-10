{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    programs.git = {
      enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autosquash = true;
        merge.ff = false;
        rerere.enabled = true;
      };
    };
  };
}
