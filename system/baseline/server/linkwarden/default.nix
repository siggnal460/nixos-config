{
  systemd.tmpfiles.rules = [
    "d /var/lib/linkwarden 0700 root root"
    "d /var/lib/postgres-linkwarden 0700 root root"
  ];

  virtualisation.oci-containers.containers = {
    linkwarden-postgres = {
      image = "docker.io/postgres:16-alpine";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [ "/run/secrets/linkwarden_secrets" ];
      volumes = [
        "/var/lib/postgres-linkwarden:/var/lib/postgresql/data"
      ];
    };

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
        NEXT_PUBLIC_AUTHELIA_ENABLED = "true";
        AUTHELIA_WELLKNOWN_URL = "https://auth.gappyland.org/.well-known/openid-configuration";
        NEXT_PUBLIC_DISABLE_REGISTRATION = "true";
        NEXT_PUBLIC_CREDENTIALS_ENABLED = "false";
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
    "linkwarden_secrets".owner = "root";
  };
}
