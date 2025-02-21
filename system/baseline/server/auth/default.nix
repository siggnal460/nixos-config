{ config, lib, ... }:
let
  domain = "gappyland.org";
  base_dn = "dc=gappyland,dc=org";
  auth_instance = "authelia-gappyland";
  redis_instance = "redis-gappyland";
  host = "x86-merkat-entry";
in
{
  networking.firewall.allowedTCPPorts = [ 3890 ];

  services = {
    redis.servers.gappyland.enable = true;

    postgresql = {
      enable = true;
      ensureDatabases = [
        auth_instance
        "lldap"
      ];
      ensureUsers = [
        {
          name = "root";
          ensureClauses.superuser = true;
        }
        {
          name = auth_instance;
          ensureDBOwnership = true;
        }
        {
          name = "lldap";
          ensureDBOwnership = true;
        }
      ];
      authentication = lib.mkForce ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust
      '';
    };

    lldap = {
      enable = true;
      settings = {
        ldap_base_dn = base_dn;
        ldap_user_email = "admin@${domain}";
        database_url = "postgresql://lldap@localhost/lldap?host=/run/postgresql";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.sops.secrets."lldap/jwt_secret".path;
        LLDAP_KEY_SEED_FILE = config.sops.secrets."lldap/key_seed".path;
        LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."lldap/admin_password".path;
      };
    };

    authelia.instances.gappyland = {
      enable = true;
      settings = {
        theme = "auto";
        authentication_backend.ldap = {
          address = "ldap://localhost:3890";
          base_dn = base_dn;
          users_filter = "(&({username_attribute}={input})(objectClass=person))";
          groups_filter = "(member={dn})";
          user = "uid=authelia,ou=people,${base_dn}";
        };
        totp = {
          disable = false;
        };
        access_control = {
          default_policy = "deny";
          rules = lib.mkAfter [
            {
              domain = "*.${domain}";
              policy = "two_factor";
            }
          ];
        };
        storage.postgres = {
          address = "unix:///run/postgresql";
          database = auth_instance;
          username = auth_instance;
          password = auth_instance;
        };
        session = {
          redis.host = "/var/run/${redis_instance}/redis.sock";
          cookies = [
            {
              domain = domain;
              authelia_url = "https://auth.${domain}";
              default_redirection_url = "https://www.${domain}";
              inactivity = "1M";
              expiration = "3M";
              remember_me = "1y";
            }
          ];
        };
        notifier = {
          smtp = {
            address = "smtp://smtp.resend.com:587";
            username = "resend";
            sender = "Gappyland <admin@updates.gappyland.org>";
          };
        };
        log = {
          level = "debug";
          keep_stdout = true;
        };
        identity_providers.oidc = {
          cors = {
            endpoints = [ "token" ];
            allowed_origins_from_client_redirect_uris = true;
          };
          authorization_policies.default = {
            default_policy = "two_factor";
            rules = [
              {
                policy = "deny";
                subject = "group:lldap_strict_readonly";
              }
            ];
          };
        };
        server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
      };
      settingsFiles = [ ./oidc_clients.yaml ];
      secrets = with config.sops; {
        jwtSecretFile = secrets."authelia/jwt_secret".path;
        oidcIssuerPrivateKeyFile = secrets."authelia/jwks".path;
        oidcHmacSecretFile = secrets."authelia/hmac_secret".path;
        sessionSecretFile = secrets."authelia/session_secret".path;
        storageEncryptionKeyFile = secrets."authelia/storage_encryption_key".path;
      };
      environmentVariables = with config.sops; {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
          secrets."authelia/lldap_authelia_password".path;
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = secrets."authelia/smtp_api_key".path;
      };
    };
  };

  users = {
    users.${auth_instance} = {
      group = auth_instance;
      extraGroups = [ redis_instance ];
      isSystemUser = true;
    };
    users.lldap = {
      group = "lldap";
      isSystemUser = true;
    };
    groups.${auth_instance} = { };
    groups.lldap = { };
  };

  systemd.services = {
    ${auth_instance} =
      let
        dependencies = [
          "lldap.service"
          "postgresql.service"
          "${redis_instance}.service"
        ];
      in
      {
        after = dependencies;
        requires = dependencies;
        serviceConfig.Environment = "X_AUTHELIA_CONFIG_FILTERS=template";
      };
    lldap =
      let
        dependencies = [
          "postgresql.service"
        ];
      in
      {
        after = dependencies;
        requires = dependencies;
        serviceConfig.DynamicUser = lib.mkForce false;
      };
  };

  sops.secrets = {
    "authelia/nextcloud/oidc_client_id".owner = auth_instance;
    "authelia/nextcloud/oidc_client_secret/hashed".owner = auth_instance;
    "authelia/hmac_secret".owner = auth_instance;
    "authelia/jwks".owner = auth_instance;
    "authelia/jwt_secret".owner = auth_instance;
    "authelia/session_secret".owner = auth_instance;
    "authelia/storage_encryption_key".owner = auth_instance;
    "authelia/lldap_authelia_password".owner = auth_instance;
    "authelia/smtp_api_key".owner = auth_instance;
    "lldap/jwt_secret".owner = "lldap";
    "lldap/key_seed".owner = "lldap";
    "lldap/admin_password".owner = "lldap";
  };
}
