{
  config,
  lib,
  ...
}:
with lib; {
  config = {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      bash.enable = mkDefault true;
    };
  };
}
