{inputs, ...}: {
  imports = let
    nixos-rpi = inputs.nixos-raspberrypi.nixosModules;
  in [
    nixos-rpi.raspberry-pi-5.base
    nixos-rpi.raspberry-pi-5.page-size-16k
    nixos-rpi.raspberry-pi-5.display-vc4
    nixos-rpi.raspberry-pi-5.bluetooth
  ];

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
}
