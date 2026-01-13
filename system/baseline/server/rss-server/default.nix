{ config, ... }:
let
  miniflux_port = "1932";
  miniflux_dbhost = "miniflux-db";
  miniflux_db = "miniflux-db";
  miniflux_dbuser = "miniflux";
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/miniflux 0744 miniflux-db miniflux"
  ];

  users = {
    users = {
      miniflux = {
        uid = 530;
        isSystemUser = true;
        group = "miniflux";
      };
      miniflux-db = {
        uid = 531;
        isSystemUser = true;
        group = "miniflux";
      };
    };
    groups = {
      miniflux = {
        gid = 530;
      };
    };
  };

  virtualisation.oci-containers.containers = {
    miniflux = {
      image = "ghcr.io/miniflux/miniflux";
      autoStart = true;
      user = "530:530";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "${miniflux_port}:8080"
      ];
      environmentFiles = [
        config.sops.templates.miniflux-env.path
      ];
      environment = {
        RUN_MIGRATIONS = "1";
        CREATE_ADMIN = "1";
        ADMIN_USERNAME = "admin";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.gappyland.org";
        OAUTH2_OIDC_PROVIDER_NAME = "Authelia";
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_REDIRECT_URL = "https://rss.gappyland.org/oauth2/oidc/callback";
        OAUTH2_USER_CREATION = "1";
      };
      volumes = [
        "/var/lib/vikunja/files:/app/vikunja/files"
        "/etc/vikunja/config.yml:/etc/vikunja/config.yml"
      ];
      extraOptions = [
        "--name=miniflux"
      ];
      dependsOn = [
        miniflux_dbhost
      ];
    };

    ${miniflux_dbhost} = {
      image = "docker.io/postgres:18-alpine";
      autoStart = true;
      user = "531:530";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        config.sops.templates.miniflux-db-env.path
      ];
      environment = {
        POSTGRES_DB = miniflux_db;
        POSTGRES_USER = miniflux_dbuser;
      };
      volumes = [
        "/var/lib/miniflux:/var/lib/postgresql"
      ];
      extraOptions = [
        "--name=${miniflux_dbhost}"
      ];
    };
  };

  sops = {
    secrets = {
      "miniflux/admin_password".owner = "miniflux";
      "miniflux/db_secret" = {
        owner = "miniflux";
        mode = "0440";
      };
      "miniflux/client_id".owner = "miniflux";
      "miniflux/client_secret".owner = "miniflux";
    };
    templates = {
      miniflux-env.content = ''
        ADMIN_PASSWORD=${config.sops.placeholder."miniflux/admin_password"}
        DATABASE_URL=postgres://${miniflux_dbuser}:${
          config.sops.placeholder."miniflux/db_secret"
        }@${miniflux_dbhost}/${miniflux_db}?sslmode=disable
        OAUTH2_CLIENT_ID=${config.sops.placeholder."miniflux/client_id"}
        OAUTH2_CLIENT_SECRET=${config.sops.placeholder."miniflux/client_secret"}
      '';
      miniflux-db-env.content = ''
        POSTGRES_PASSWORD=${config.sops.placeholder."miniflux/db_secret"}
      '';
    };
  };
}
