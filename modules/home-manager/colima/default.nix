{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    outputs.commonModules.overlays
  ];

  home.packages = with pkgs; [
    stable.colima
    docker-client
    dive
    docker-credential-helpers
    amazon-ecr-credential-helper
  ];
}
