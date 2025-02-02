{ config, lib, ... }:
let
  domain = "gappyland.org";
  base_dn = "dc=gappyland,dc=org";
  auth_instance = "authelia-gappyland";
  redis_instance = "redis-gappyland";
  host = "x86-merkat-entry";
  ldap_cfg = config.services.lldap;
in
{
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
        LLDAP_JWT_SECRET_FILE = config.sops.secrets."${host}/lldap/jwt_secret".path;
        LLDAP_KEY_SEED_FILE = config.sops.secrets."${host}/lldap/key_seed".path;
        LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."${host}/lldap/admin_password".path;
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
        access_control = {
          default_policy = "deny";
          rules = lib.mkAfter [
            {
              domain = "*.${domain}";
              policy = "one_factor";
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
              inactivity = "1M";
              expiration = "3M";
              remember_me = "1y";
            }
          ];
        };
        notifier.smtp = {
          address = "smtp.mail.yahoo.com:465";
          username = "gappyland@yahoo.com";
          sender = "admin@${domain}";
        };
        log.level = "info";
        #identity_providers.oidc = {
        #  cors = {
        #    endpoints = [ "token" ];
        #    allowed_origins_from_client_redirect_uris = true;
        #  };
        #  authorization_policies.default = {
        #    default_policy = "one_factor";
        #    rules = [
        #      {
        #        policy = "deny";
        #        subject = "group:lldap_strict_readonly";
        #      }
        #    ];
        #  };
        #};
        server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
      };
      #settingsFiles = [ ./oidc_clients.yaml ];
      secrets = with config.sops; {
        jwtSecretFile = secrets."${host}/authelia/jwt_secret".path;
        #oidcIssuerPrivateKeyFile = secrets."${host}/authelia/jwks".path;
        #oidcHmacSecretFile = secrets."${host}/authelia/hmac_secret".path;
        sessionSecretFile = secrets."${host}/authelia/session_secret".path;
        storageEncryptionKeyFile = secrets."${host}/authelia/storage_encryption_key".path;
      };
      environmentVariables = with config.sops; {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
          secrets."${host}/authelia/lldap_authelia_password".path;
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = secrets."${host}/authelia/smtp_password".path;
      };
    };

    caddy = {
      virtualHosts = {
        "auth.${domain}".extraConfig = ''
          					reverse_proxy :9091
          				'';
        "users.${domain}".extraConfig = ''
          					reverse_proxy :${toString ldap_cfg.settings.http_port}
          				'';
      };
      extraConfig = ''
        (auth) {
            forward_auth :9091 {
                uri /api/authz/forward-auth
                copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
        }
      '';
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
    "${host}/authelia/hmac_secret".owner = auth_instance;
    "${host}/authelia/jwks".owner = auth_instance;
    "${host}/authelia/jwt_secret".owner = auth_instance;
    "${host}/authelia/session_secret".owner = auth_instance;
    "${host}/authelia/storage_encryption_key".owner = auth_instance;
    "${host}/authelia/lldap_authelia_password".owner = auth_instance;
    "${host}/authelia/smtp_password".owner = auth_instance;
    "${host}/lldap/jwt_secret".owner = "lldap";
    "${host}/lldap/key_seed".owner = "lldap";
    "${host}/lldap/admin_password".owner = "lldap";
  };
}
