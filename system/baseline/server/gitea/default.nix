{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    "d /var/lib/gitea 0750 gitea wheel"
    "d /var/lib/gitea-db 0750 gitea-db wheel"
  ];

  users = {
    users = {
      gitea = {
        uid = 740;
        group = "gitea";
      };
      gitea-db = {
        uid = 741;
        group = "gitea";
      };
    };
    groups = {
      gitea = {
        gid = 740;
      };
    };
  };

  virtualisation.oci-containers.containers = {
    gitea = {
      image = "docker.gitea.com/gitea:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "3003:3000"
        "222:22"
      ];
      environmentFiles = [ "/run/secrets/gitea_secrets" ];
      environment = {
        USER_UID = "740";
        USER_GID = "740";
        TZ = "America/Denver";
        GITEA__DEFAULT__APP_NAME = "Gappyland Gitea";
        GITEA__database__DB_TYPE = "mysql";
        GITEA__database__HOST = "gitea-db:3306";
        GITEA__database__NAME = "gitea";
        GITEA__database__USER = "gitea";
        GITEA__server__ROOT_URL = "https://gitea.gappyland.org";
        GITEA__oauth2_client__ENABLE_AUTO_REGISTRATION = "true";
        GITEA__oauth2_client__OPENID_CONNECT_SCOPES = "email profile";
        GITEA__oauth2_client__USERNAME = "nickname";
        GITEA__oauth2_client__UPDATE_AVATAR = "true";
        GITEA__oauth2_client__ACCOUNT_LINKING = "auto";
        GITEA__openid__SIGNIN = "false";
        GITEA__openid__ENABLE_OPENID_SIGNIN = "false";
        GITEA__openid__ENABLE_OPENID_SIGNUP = "true";
        GITEA__openid__WHITELISTED_URIS = "auth.gappyland.org";
        GITEA__service__DISABLE_REGISTRATION = "false";
        GITEA__service__ALLOW_ONLY_EXTERNAL_REGISTRATION = "true";
        GITEA__service__SHOW_REGISTRATION_BUTTON = "false";
        # Note: best I can tell authelia openid needs to be configured ad hoc
      };
      volumes = [
        "/var/lib/gitea:/data"
      ];
      extraOptions = [
        "--name=gitea"
      ];
      dependsOn = [ "gitea-db" ];
    };
    gitea-db = {
      image = "docker.io/library/mariadb:11.4";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [ "/run/secrets/gitea-db_secrets" ];
      environment = {
        PUID = "741";
        PGID = "740";
        TZ = "America/Denver";
        MYSQL_DATABASE = "gitea";
        MYSQL_USER = "gitea";
      };
      volumes = [
        "/var/lib/gitea-db:/config"
      ];
      extraOptions = [
        "--name=gitea-db"
      ];
    };
  };

  sops.secrets = {
    "gitea_secrets".owner = "gitea";
    "gitea-db_secrets".owner = "gitea-db";
  };
}
