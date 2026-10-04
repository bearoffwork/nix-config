{
  inputs,
  config,
  ...
}:
{
  # Define the sops secret pointing to your env file
  sops.secrets."librechat.env" = {
    sopsFile = "${inputs.self.outPath}/secrets/librechat.env";
    format = "dotenv"; # Tells sops-nix that this is a plain KEY=VALUE dot-env file
    mode = "0640";
    owner = config.services.librechat.user;
    group = config.services.librechat.group;
  };

  services.librechat = {
    enable = true;
    # enableLocalDB = true;
    # openFirewall = true;

    env = {
      HOST = "::";
      PORT = "8080";
      MONGO_URI = "mongodb://localhost:27017/LibreChat";
      ALLOW_REGISTRATION = true;
    };

    settings = {
      version = "1.3.16";

      cache = false;
      endpoints = {
        custom = [
          {
            name = "llamacpp";
            apiKey = "very-secure-api-key";
            baseURL = "http://localhost:8731/v1";
            models = {
              default = [
                "halogen-qwen3.8-flash-next"
              ];
              fetch = true;
            };
            titleConvo = true;
            titleModel = "current_model";
          }
          # {
          #   name = "halogen";
          #   apiKey = "very-secure-api-key";
          #   baseURL = "http://localhost:8731/v1";
          #   models = {
          #     default = [
          #       "halogen-qwen3.8-flash-next"
          #     ];
          #     fetch = true;
          #   };
          #   titleConvo = true;
          #   titleModel = "current_model";
          # }
        ];
      };

      webSearch = {
        # serperApiKey = "\${SERPER_API_KEY}";
        # searxngInstanceUrl = "\${SEARXNG_INSTANCE_URL}";
        # searxngApiKey = "\${SEARXNG_API_KEY}";
        searchProvider = "serper"; # Options: "serper", "searxng"

        firecrawlApiKey = "\${FIRECRAWL_API_KEY}";
        firecrawlApiUrl = "\${FIRECRAWL_API_URL}";
        scraperType = "firecrawl"; # Options: "firecrawl", "serper"

        jinaApiKey = "\${JINA_API_KEY}";
        jinaApiUrl = "\${JINA_API_URL}";
        cohereApiKey = "\${COHERE_API_KEY}";
        rerankerType = "jina"; # Options: "jina", "cohere"

        scraperTimeout = 7500; # Timeout in milliseconds for scraper requests (default: 7500)
      };
    };

    # Feed the decrypted sops secret file directly to the service
    credentialsFile = config.sops.secrets."librechat.env".path;
  };

  virtualisation.oci-containers.containers = {
    mongodb = {
      podman.user = "librechat";
      image = "mongo:7";
      autoStart = true;
      ports = [
        "27017:27017"
      ];
      volumes = [
        "librechat-mongodb:/data/db"
      ];
    };
  };

  # services.searx = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       bind_address = "::1";
  #       port = 30080;
  #       secret_key = "@SEARXNG_API_KEY@";
  #     };
  #     search = {
  #       formats = [
  #         "html"
  #         "json"
  #       ];
  #     };
  #     # engines = [
  #     #   {
  #     #     name = "google";
  #     #     enabled = true;
  #     #   }
  #     #   {
  #     #     name = "duckduckgo";
  #     #     enabled = true;
  #     #   }
  #     #   # {
  #     #   #   name = "brave";
  #     #   #   enabled = true;
  #     #   # }
  #     # ];
  #
  #   };
  # };

  users.users.librechat = {
    isSystemUser = true;
    autoSubUidGidRange = true;
    linger = true;
    home = "/var/lib/librechat";
    createHome = true;
  };

}
