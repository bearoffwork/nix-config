{
  lib,
  config,
  ...
}:
{
  config = {
    networking.hostName = lib.mkDefault config.system.name;
    time.timeZone = "Asia/Taipei";
  };
}
