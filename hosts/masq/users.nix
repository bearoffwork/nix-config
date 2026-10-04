{
  users.users.bear = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$8ctf8SWrD1hJp85TDM782/$kdTg.uwuw69yt.6o/GZjEg5owLLOMHDJ6hIh9p5XA31";
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
