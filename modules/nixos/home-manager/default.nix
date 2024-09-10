{
  config,
  inputs,
  lib,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs outputs;};
    }
  ];
}
