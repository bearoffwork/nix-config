{
  inputs,
  ...
}:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Disable compression for faster builds
  # isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  isoImage.compressImage = false;

  users.users.nixos = {
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcb/6hU5JzxclQYwUwARgj7mnE389S6/R6QjpII30Sv"
    ];
  };

  services.getty.autologinUser = "nixos";

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
}
