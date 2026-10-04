{
  lib,
  config,
  systemName,
  ...
}:
{
  imports = [
    ./i18n.nix
  ];

  networking.hostName = lib.mkDefault systemName;
  system.name = lib.mkDefault systemName;
  system.stateVersion = lib.mkDefault "26.05";

  time.timeZone = "Asia/Taipei";

}
