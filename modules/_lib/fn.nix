{lib, ...}: {
  mkUsualOption = name:
    lib.mkOption {
      default = true;
      example = true;
      description = "Whether to enable ${name} as usual";
      type = lib.types.bool;
    };
  mkUsualBefore = lib.mkOverride 550;
}
