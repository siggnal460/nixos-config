{
  systemd.tmpfiles.rules = [
    "d /var/lib/linkwarden 0700 linkwarden linkwarden"
    "d /var/lib/linkwarden-postgres 0700 linkwarden linkwarden"
  ];

  services.ollama = {
    loadModels = [
      "phi3:mini-4k"
    ];
  };

  users = {
    users = {
      linkwarden = {
        uid = 715;
        isSystemUser = true;
        group = "linkwarden";
      };
    };
    groups = {
      linkwarden = {
        gid = 715;
      };
    };
  };

  virtualisation.oci-containers.containers = {
    linkwarden-postgres = {
      image = "docker.io/postgres:16-alpine";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [ "/run/secrets/linkwarden_secrets" ];
      environment = {
        PUID = "715";
        PGID = "715";
      };
      volumes = [
        "/var/lib/linkwarden-postgres:/var/lib/postgresql/data"
      ];
    };

    # Changing settings is broken with authelia using my naming scheme https://github.com/linkwarden/linkwarden/issues/736
    linkwarden = {
      image = "ghcr.io/linkwarden/linkwarden:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "3001:3000"
      ];
      environmentFiles = [ "/run/secrets/linkwarden_secrets" ];
      environment = {
        PUID = "715";
        PGID = "715";
        NEXT_PUBLIC_AUTHELIA_ENABLED = "true";
        AUTHELIA_WELLKNOWN_URL = "https://auth.gappyland.org/.well-known/openid-configuration";
        NEXT_PUBLIC_DISABLE_REGISTRATION = "true";
        NEXT_PUBLIC_CREDENTIALS_ENABLED = "false";
        NEXT_PUBLIC_OLLAMA_ENDPOINT_URL = "http://host.docker.internal:11434";
        OLLAMA_MODEL = "phi3:mini-4k";
      };
      volumes = [
        "/var/lib/linkwarden:/data/data"
      ];
      extraOptions = [
        "--name=linkwarden"
      ];
      dependsOn = [
        "linkwarden-postgres"
      ];
    };
  };

  sops.secrets = {
    "linkwarden_secrets".owner = "linkwarden";
  };
}
