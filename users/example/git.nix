{
  config,
  lib,
  username,
  ...
}: {
  programs.git = {
    # Use special args `username` passed from home-manager, spedified in lib/mkHomeCfg.nix
    # userNmae = username;
    # userEmail = "${username}@eui.money";

    # Or just hard code it.
    # userNmae = "example";
    # userEmail = "user@example.com";

    # Here's a show case how do define git aliases:
    # aliases = {
    #   sw = "show";
    #   st = "status";
    #   ch = "checkout";
    #   pu = "push";
    #   pl = "pull";
    #   aa = "add -A";
    #   cm = "commit -m";
    #   cam = "commit -am";
    #   caa = "commit -a --amend";
    #   caam = "commit -a --amend -m";
    #   mr = "merge --no-ed";
    # };
  };
}
