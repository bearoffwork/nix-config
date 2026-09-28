{
  outputs,
  lib,
  ...
}:
{
  nixpkgs = {
    config = {
      rocmSupport = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "cloudflare-warp"
          "mongodb"
        ];
    };
    overlays = [
      outputs.overlays.rocm-only-gfx1151
      outputs.overlays.unstable-pkgs
    ];
  };

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
