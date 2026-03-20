{
  systemd.tmpfiles.rules = [
    "d /var/lib/matrix 0770 synapse wheel"
    "d /etc/matrix 0770 synapse wheel"
  ];

  users.users = {
    synapse = {
      uid = 991;
      isSystemUser = true;
      group = "synapse";
    };
  };

  users.groups = {
    synapse = {
      gid = 991;
    };
  };

  environment.etc = {
    "matrix/homeserver.yml" = {
      source = lib.mkForce config.sops.templates.matrix-config.path;
      user = "synapse";
      group = "synapse";
      mode = "0770";
    };
  };

  sops.templates.matrix-config = {
    owner = "synapse";
    file = (pkgs.formats.yaml { }).generate "yaml" {
      serverName = "gappyland.org";
      pidFile = "${datadir}/homeserver.pid";
      listeners = [
        {
          bindAddresses = ["::1" "127.0.0.1"];
          port = 8008;
          resources = [
            {
              compress = false;
              names = ["client" "federation"];
            }
          ];
          tls = false;
          type = "http";
          xForwarded = true;
        }
      ];
      database = {
        name = "sqlite3";
        args = {
          database = "${datadir}/homeserver.db";
        };
      };
      logConfig = "${confdir}/SERVERNAME.log.config";
      mediaStorePath = "${datadir}/media_store";
      signingKeyPath = "${confdir}/SERVERNAME.signing.key";
      trustedKeyServers = [
        {
          serverName = "matrix.org";
        }
      ];
      oidcProviders = [
        {
          user_profile_method = 'userinfo_endpoint'; #https://www.authelia.com/integration/openid-connect/clients/synapse/#configuration-escape-hatch
          idpId = "authelia";
          idpName = "Authelia";
          idpIcon = "mxc://authelia.com/cKlrTPsGvlpKxAYeHWJsdVHI";
          discover = true;
          issuer = "https://auth.gappyland.org";
          clientId = "${config.sops.placeholder."synapse/oidc_client_id"}";
          clientSecret = "${config.sops.placeholder."synapse/oidc_client_secret"}";
          scopes = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          allowExistingUsers = true;
          userMappingProvider = {
            config = {
              subjectTemplate = "{{ user.sub }}";
              localpartTemplate = "{{ user.preferred_username }}";
              displayNameTemplate = "{{ user.name }}";
              emailTemplate = "{{ user.email }}";
            };
          };
          attributeRequirements = [
            {
              attribute = "groups";
              value = "synapse-users";
            }
          ];
        }
      ];
    };
  };

  virtualisation.oci-containers.containers = {
    synapse = {
      image = "docker.io/matrixdotorg/synapse:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8008:8008"
      ];
      environment = {
        SYNAPSE_SERVER_NAME = "gappyland.org";
        SYNAPSE_CONFIG_DIR = "/config";
        SYNAPSE_REPORT_STATS = "no";
        UID = "991";
        GID = "991";
        TZ = "America/Denver";
      };
      volumes = [
        "/var/lib/matrix:/data"
        "/etc/matrix:/config"
      ];
      extraOptions = [
        "--name=synapse"
      ];
    };

    element = {
      image = "docker.io/vectorim/element-web:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8088:80"
      ];
      extraOptions = [
        "--name=element"
      ];
    };
  };
}
