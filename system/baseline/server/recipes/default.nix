{ config, ... }:
let
  tandoor_data_dir =  "/var/lib/tandoor";
	tandoor_port = "5413";
	postgres_host = "tandoor-db";
	postgres_db = "tandoor_recipes";
	postgres_user = "tandoor_recipes";
	postgres_port = "5432";
	hosts = "recipes.gappyland.org";
	tz = "America/Denver";
in
{
  systemd.tmpfiles.rules = [
    "d ${tandoor_data_dir} 0770 root wheel"
    "d ${tandoor_data_dir}/staticfiles 0770 root wheel"
    "d ${tandoor_data_dir}/mediafiles 0770 root wheel"
    "d ${tandoor_data_dir}/tandoor-db 0770 root wheel"
	];

  virtualisation.oci-containers.containers = {
    tandoor-recipes = {
      image = "docker.io/vabene1111/recipes:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "${tandoor_port}:80"
      ];
			environmentFiles = [
			  config.sops.templates.tandoor-env.path
			];
      environment = {
				ALLOWED_HOSTS = hosts;
				DB_ENGINE = "django.db.backends.postgresql";
				ENABLE_SIGNUP = "0";
				ENABLE_PDF_EXPORT = "1";
				GUNICORN_MEDIA = "0";
				POSTGRES_HOST = postgres_host;
				POSTGRES_DB = postgres_db;
				POSTGRES_PORT = postgres_port;
				POSTGRES_USER = postgres_user;
				REMOTE_USER_AUTH = "1";
				SOCIAL_PROVIDERS = "allauth.socialaccount.providers.openid_connect";
        TZ = tz;
      };
      volumes = [
        "${tandoor_data_dir}/staticfiles:/opt/recipes/staticfiles"
        "${tandoor_data_dir}/mediafiles:/opt/recipes/mediafiles"
      ];
      extraOptions = [
        "--name=tandoor"
      ];
			dependsOn = [
			  "tandoor-db"
			];
    };

    ${postgres_host} = {
      image = "docker.io/postgres:16-alpine";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
			environmentFiles = [
			  config.sops.templates.tandoor-db-env.path
			];
      environment = {
				POSTGRES_PORT = postgres_port;
				POSTGRES_DB = postgres_db;
				POSTGRES_USER = postgres_user;
        TZ = tz;
      };
      volumes = [
        "${tandoor_data_dir}/tandoor-db:/var/lib/postgresql/data"
      ];
      extraOptions = [
        "--name=tandoor-db"
      ];
    };
	};

  sops = {
	  secrets = {
      "tandoor/secret" = {};
      "tandoor/db_secret" = {};
      "tandoor/client_id" = {};
      "tandoor/client_secret" = {};
		};
		templates = {
		  tandoor-env.content = ''
				SECRET_KEY=${config.sops.placeholder."tandoor/secret"}
				POSTGRES_PASSWORD=${config.sops.placeholder."tandoor/db_secret"}
				SOCIALACCOUNT_PROVIDERS={"openid_connect":{"SCOPE":["openid","profile","email"],"OAUTH_PKCE_ENABLED":true,"APPS":[{"provider_id":"authelia","name":"Authelia","client_id":"${config.sops.placeholder."tandoor/client_id"}","secret":"${config.sops.placeholder."tandoor/client_secret"}","settings":{"server_url":"https://auth.gappyland.org/.well-known/openid-configuration","token_auth_method":"client_secret_basic"}}]}}
			'';
		  tandoor-db-env.content = ''
				POSTGRES_PASSWORD=${config.sops.placeholder."tandoor/db_secret"}
			'';
		};
	};
}
