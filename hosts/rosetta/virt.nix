{
  config,
  pkgs,
  ...
}:

{
  # 1. Enable Podman and disable Docker
  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true; # Creates a `docker` alias for podman

      # Recommended for rootless containers to function correctly
      defaultNetwork.settings.dns_enabled = true;

      autoPrune = {
        enable = true;
        flags = [ ];
        dates = "weekly";
      };
    };

    containers.containersConf.settings = {
      engine = {
        env = [
          "HTTP_PROXY=socks5h://127.0.0.1:40000"
          "HTTPS_PROXY=socks5h://127.0.0.1:40000"
          "NO_PROXY=localhost,127.0.0.1,::1,[::1],::,fd00::/8"
        ];
      };
    };

    oci-containers = {
      backend = "podman";

      # containers.halogen = {
      #   podman.user = "booth";
      #   image = "ghcr.io/peonist-ai/halogen-flash-server:0.11.9";
      #   autoStart = true;
      #
      #   ports = [
      #     "8731:8731"
      #   ];
      #   volumes = [
      #     "${config.users.users.booth.home}/models/peonist-ai:/models:ro"
      #     "${config.users.users.booth.home}/models/peonist-ai/tokenizer:/tokenizer:ro"
      #   ];
      #   devices = [
      #     "/dev/kfd"
      #     "/dev/dri"
      #   ];
      #   extraOptions = [
      #     "--group-add=keep-groups"
      #     "--security-opt=seccomp=unconfined"
      #     "--ipc=host"
      #     "--ulimit=memlock=-1:-1"
      #   ];
      # };
    };
  };

  users.users.booth = {
    isSystemUser = true;
    autoSubUidGidRange = true;
    linger = true;
    group = "booth";

    home = "/var/lib/booth";
    createHome = true;

    extraGroups = [
      "render"
      "video"
    ];
  };

  users.groups.booth = { };
}
