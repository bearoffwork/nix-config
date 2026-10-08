{
  inputs,
  lib,
  ...
}:
let
  credentials = {
    initialHashedPassword = lib.mkForce "$y$j9T$T1DbK/X481KrRP8rPLrZJ.$6zZVtcdmMEPDAsiaktM5rqhJ2AOWvOFWvDlZNdaDoK8";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcb/6hU5JzxclQYwUwARgj7mnE389S6/R6QjpII30Sv"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPqnVSfFBTMqSOmgrTCl8rPUDxakVeNTyBTMVuTgqDC bear@bench.bearoff.work"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBa2WGEtVhHDLyyTXO2pbth+d4MNMVhaiO2ltYuBtkjUAAAABHNzaDo= code@bearoff.work"
    ];
  };
in
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  image.baseName = lib.mkForce "nixos-linode-${inputs.self.shortRev or inputs.self.dirtyShortRev}";
  isoImage = {
    compressImage = false;
  };

  users.users.nixos = {
    extraGroups = [ "wheel" ];
  }
  // credentials;

  users.users.root = credentials;

  boot.supportedFilesystems.zfs = lib.mkForce false;

  # configure LISH
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  services.getty.autologinUser = "nixos";

  security.sudo.wheelNeedsPassword = false;

  # Don't hardcode - allow override via --system
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "25.11";
}
