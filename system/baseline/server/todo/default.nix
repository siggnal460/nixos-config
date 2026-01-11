{ config, ... }:
let
  vikunja_port = "3456";
  postgres_host = "vikunja-db";
  postgres_db = "vikunja";
  postgres_user = "vikunja";
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/vikunja 0744 vikunja vikunja"
    "d /var/lib/vikunja/files 0770 vikunja wheel"
    "d /var/lib/vikunja/db 0770 vikunja-db wheel"
    "d /etc/vikunja 0770 vikunja wheel"
  ];

  users = {
    users = {
      vikunja = {
        uid = 500;
        isSystemUser = true;
        group = "vikunja";
      };
      vikunja-db = {
        uid = 501;
        isSystemUser = true;
        group = "vikunja";
      };
    };
    groups = {
      vikunja = {
        gid = 500;
      };
    };
  };

  environment.etc = {
    "vikunja/config.yml" = {
      source = config.sops.templates.vikunja-config.path;
      user = "vikunja";
      group = "wheel";
      mode = "0770";
    };
  };

  virtualisation.oci-containers.containers = {
    vikunja = {
      image = "docker.io/vikunja/vikunja";
      autoStart = true;
      user = "500:500";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "${vikunja_port}:3456"
      ];
      environmentFiles = [
        config.sops.templates.vikunja-env.path
      ];
      environment = {
        VIKUNJA_SERVICE_PUBLICURL = "https://todo.gappyland.org";
        VIKUNJA_DATABASE_HOST = postgres_host;
        VIKUNJA_DATABASE_TYPE = "postgres";
        VIKUNJA_DATABASE_USER = postgres_user;
        VIKUNJA_DATABASE_DATABASE = postgres_db;
      };
      volumes = [
        "/var/lib/vikunja/files:/app/vikunja/files"
        "/etc/vikunja/config.yml:/etc/vikunja/config.yml"
      ];
      extraOptions = [
        "--name=vikunja"
      ];
      dependsOn = [
        "vikunja-db"
      ];
    };

    ${postgres_host} = {
      image = "docker.io/postgres:18-alpine";
      autoStart = true;
      user = "501:500";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        config.sops.templates.vikunja-db-env.path
      ];
      environment = {
        POSTGRES_DB = postgres_db;
        POSTGRES_USER = postgres_user;
      };
      volumes = [
        "/var/lib/vikunja/db:/var/lib/postgresql"
      ];
      extraOptions = [
        "--health-cmd=pg_isready -h localhost -U vikunja"
        "--health-interval=2s"
        "--health-start-period=30s"
      ];
    };
  };

  sops = {
    secrets = {
      "vikunja/jwt_secret".owner = "vikunja";
      "vikunja/db_secret" = {
        owner = "vikunja";
        mode = "0440";
      };
      "vikunja/client_id".owner = "vikunja";
      "vikunja/client_secret".owner = "vikunja";
    };
    templates = {
      vikunja-config.content = ''
        auth:
          local:
            enabled: false
          openid:
            enabled: true
            providers:
              authelia:
                name: 'Authelia'
                authurl: 'https://auth.gappyland.org'
                clientid: '${config.sops.placeholder."vikunja/client_id"}'
                clientsecret: '${config.sops.placeholder."vikunja/client_secret"}'
                scope: 'openid profile email' '';
      vikunja-env.content = ''
        				VIKUNJA_DATABASE_PASSWORD=${config.sops.placeholder."vikunja/db_secret"}
        				VIKUNJA_SERVICE_JWTSECRET=${config.sops.placeholder."vikunja/jwt_secret"}
        			'';
      vikunja-db-env.content = ''
        				POSTGRES_PASSWORD=${config.sops.placeholder."vikunja/db_secret"}
        			'';
    };
  };
}
