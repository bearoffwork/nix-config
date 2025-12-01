{lib, ...}: {
  mkEnableOption = name:
    lib.mkEnableOption name
    // {
      default = true;
      description = "Whether to enable ${name} as usual.";
    }; # and "usual" so make it enabled by default.

  # lib.usual.value = "something"
  #  keeps priority consistent with the "usual" theme, also, sounds cool
  value = lib.mkOverride 600;
}
