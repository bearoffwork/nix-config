{
  inputs,
  outputs,
  self,
  ...
}:
inputs.nixpkgs.lib.extend (
  final: prev: let
    lib = inputs.nixpkgs.lib;
  in {
    x = import ./x {inherit inputs outputs self lib;};
    usual = import ./usual {inherit lib;};
  }
)
