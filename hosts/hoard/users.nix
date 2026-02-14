{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.bear = ../../home-manager/hoard.nix;
  # home-manager.extraSpecialArgs = {};

  users.users = {
    bear = {
      initialHashedPassword = "$y$j9T$XgjePxnpRHCCyIxWN0DFu1$pW2e6RvmknonD1PIc5LnFOQ.ppUDn71H/a1q4n9qgs8";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcb/6hU5JzxclQYwUwARgj7mnE389S6/R6QjpII30Sv"
      ];
      extraGroups = [ "wheel" ];
    };

    homepage = {
      isSystemUser = true;
      group = "homepage";
      extraGroups = [ "sensors" ];
    };

  };

  users.groups.homepage = { };

  security.sudo.wheelNeedsPassword = false;
}
