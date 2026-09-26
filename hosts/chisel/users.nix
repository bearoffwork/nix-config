{ ... }:
{
  users.users.bear = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$MNX/3RpmXUWmZ7c040llV/$Cr/4LOk7Ea/pNZ6/4mIkHhb2JMcEVPTy44toW9X4fY5";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcb/6hU5JzxclQYwUwARgj7mnE389S6/R6QjpII30Sv"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPqnVSfFBTMqSOmgrTCl8rPUDxakVeNTyBTMVuTgqDC bear@bench.bearoff.work"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBa2WGEtVhHDLyyTXO2pbth+d4MNMVhaiO2ltYuBtkjUAAAABHNzaDo= code@bearoff.work"
    ];
    extraGroups = [
      "wheel"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}
