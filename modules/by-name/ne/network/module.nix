{
  lib,
  sysname,
  ...
}: {
  config = {
    networking.hostName = lib.mkDefault sysname;
    time.timeZone = "Asia/Taipei";
  };
}
