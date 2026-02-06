{
  lib,
  config,
  ...
}:
{
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_DK.UTF-8";
  };
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_DK.UTF-8/UTF-8"
    "zh_TW.UTF-8/UTF-8"
  ];
}
