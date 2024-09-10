{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}: {
  config = {
    nix = {
      # use latest nix
      package = lib.mkDefault pkgs.nixVersions.latest;

      settings = {
        # Necessary for using flakes on this system.
        experimental-features = "nix-command flakes";
        # Opinionated: follow XDG Base Directory to keep home directory clean.
        # spec: https://specifications.freedesktop.org/basedir-spec/latest/index.html
        # see also https://wiki.archlinux.org/title/XDG_Base_Directory
        use-xdg-base-directories = true;
      };
    };

    nixpkgs.config.allowUnfree = lib.mkDefault true;
  };
}
