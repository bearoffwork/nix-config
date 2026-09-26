{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 1;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    initrd = {
      kernelModules = [
        "amdgpu"
      ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "uas"
        "sd_mod"
      ];
    };
    kernelPackages = pkgs.unstable.linuxPackages_latest;
    supportedFilesystems.zfs = lib.mkForce false;
    extraModulePackages = with config.boot.kernelPackages; [ ryzen-smu ];
    kernelModules = [
      "kvm-amd"
      "ryzen_smu"
    ];
    kernelParams =
      let
        pageLimit = toString (108 * (256 * 1024));
      in
      [
        "nohibernate"
        ("ttm.pages_limit=" + pageLimit)
        ("ttm.page_pool_size=" + pageLimit)
        "amd_iommu=on"
        "iommu=pt"
      ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/891a8c37-107e-4e50-9430-dadb59a81ab0";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/5B5D-F7F4";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # for python env and oci
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

  swapDevices = [ ];

  hardware = {
    graphics = {
      enable = true;
    };
    amdgpu.initrd.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # bluetooth = {
    #   enable = true;
    #   powerOnBoot = true;
    #   settings = {
    #     General = {
    #       Experimental = true;
    #       Privacy = "device";
    #       JustWorksRepairing = "always";
    #       Class = "0x000100";
    #       FastConnectable = true;
    #     };
    #   };
    # };
  };

  services.fwupd.enable = true;

  services.tuned = {
    enable = true;
    profiles = {
      strix-halo = {
        main = {
          # include = "throughput-performance";
          include = "accelerator-performance";
        };
      };
    };
  };

  systemd.services.tuned-set-profile = {
    description = "Set TuneD profile";
    after = [ "tuned.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      # ExecStart = "${pkgs.tuned}/bin/tuned-adm profile throughput-performance";
      ExecStart = "${pkgs.tuned}/bin/tuned-adm profile accelerator-performance";
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
