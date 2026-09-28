{
  nix.sshServe = {
    enable = true;
    write = true;
    trusted = true;
    protocol = "ssh-ng";
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGWvwlenubUueYoK8bE/DgoZ8nkxgxqopaB0MWlXX9e root@hoard.bearoff.work"
    ];
  };
}
