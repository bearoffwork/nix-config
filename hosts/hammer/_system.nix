{
  modules = [
    (
      {
        inputs,
        modulesPath,
        pkgs,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
          inputs.disko.nixosModules.disko
          ./disko.nix
          ./hardware.nix
          ./users.nix
          ./zfs.nix
        ];

        nixpkgs.config.allowUnfree = true;

        boot.supportedFilesystems = [ "zfs" ];

        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.timeout = 1;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.efi.efiSysMountPoint = "/boot/efi";

        environment.systemPackages = with pkgs; [
          # wl-clipboard
          # mesa-demos
          # adwaita-icon-theme
          # flat-remix-icon-theme
          pciutils
        ];

        # hardware = {
        #   enableRedistributableFirmware = true;
        #   graphics = {
        #     enable = true;
        #   };
        # };

        programs.zsh = {
          enable = true;
        };

        users.defaultUserShell = pkgs.zsh;

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "25.11";
      }
    )
  ];
}
