{
  lib,
  config,
  ...
}:
{
  # Add system.name option for Darwin (NixOS has it built-in)
  options = {
    system.name = lib.mkOption {
      type = lib.types.str;
      description = "The name of the system, used for identification and derivation names.";
    };
  };
}
