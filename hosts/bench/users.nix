{
  pkgs,
  ...
}:
{
  users.defaultUserShell = pkgs.zsh;
  users.users = {
    bear = {
      extraGroups = [
        "wheel"
        "podman"
      ];
    };
  };

  programs.zsh.enable = true;
}
