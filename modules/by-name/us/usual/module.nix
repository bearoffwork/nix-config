{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.usual.packages;

  packages = {
    default = with pkgs; [
      neovim
      git
      curl
      wget
      fd
      ripgrep
      htop
      viddy
      jq
    ];

    extraGroups = {
      monitoring = {
        description = "system monitoring utils";
        packages = with pkgs; [
          bottom
          powertop
        ];
      };
    };
  };

  # Dynamically generate options for each extra group
  groupOptions = lib.mapAttrs (
    name: group:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include ${group.description}";
    }
  ) packages.extraGroups;

  # Build selected packages based on options
  selectedPackages = lib.flatten (
    packages.default
    ++ (lib.mapAttrsToList (name: group: lib.optionals cfg.${name} group.packages) packages.extraGroups)
  );
in
{
  options.usual.packages = {
    enable = lib.mkEnableOption "usual packages" // {
      default = false;
    };
  }
  // groupOptions;

  config = lib.mkIf cfg.enable {
    environment.systemPackages = selectedPackages;
  };
}
