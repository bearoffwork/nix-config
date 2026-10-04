{
  users.users.nixbld = {
    isSystemUser = true;
    group = "nixbld-remote";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGWvwlenubUueYoK8bE/DgoZ8nkxgxqopaB0MWlXX9e root@hoard.bearoff.work"
    ];
  };

  users.groups.nixbld-remote = { };

  nix.settings = {
    trusted-users = [ "nixbld" ];
    cores = 2;
    max-jobs = 16;
  };
}
