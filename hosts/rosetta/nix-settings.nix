{
  lib,
  ...
}:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true;

    substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
  };

  systemd.services.nix-daemon.environment = {
    HTTPS_PROXY = "socks5h://127.0.0.1:40000";
    NO_PROXY = "api.github.com";
  };
}
