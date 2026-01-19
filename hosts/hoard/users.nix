{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
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

  security.sudo.extraRules = [
    {
      # allow to run nixos-rebuild commands without password
      users = [ "bear" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nix-env -p /nix/var/nix/profiles/system --set /nix/store/*-nixos-system-*";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait true";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait /nix/store/*-nixos-system-*/bin/switch-to-configuration switch";
          options = [ "NOPASSWD" ];
        }
      ];
    }
    {
      groups = [ "sensors" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/storcli64 /c0 show temperature J";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/storcli64 /c0 show all J";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
