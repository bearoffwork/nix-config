{
  lib,
  sysname,
  ...
}:
{
  config.networking.hostName = lib.mkDefault sysname;
}
