{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ 3004 ];

  users = {
    users."invidious" = {
      isSystemUser = true;
      group = "invidious";
    };
    groups."invidious" = { };
  };

  services.invidious = {
    enable = true;
    port = 3004;
    sig-helper.enable = true;
    #hmacKeyFile = config.sops.templates."invidious_hmac_key.json".path;
    extraSettingsFile = config.sops.templates."invidious_secrets.json".path;
    #extraSettingsFile = "/run/secrets/invidious/extra_settings";
    settings = {
      default_user_preferences = {
        locale = "en-US";
        quality = "hd720";
        dark_mode = "true";
      };
      https_only = false;
      database = {
        createLocally = true;
        port = 5432;
        host = "/run/postgresql";
      };
      db = {
        dbname = "invidious";
        user = "invidious";
        passwordFile = "/run/secrets/invidious/db_password";
      };
    };
  };

  sops.secrets = {
    "invidious/hmac_key" = {
      owner = "invidious";
      group = "invidious";
    };
    "invidious/db_password" = {
      owner = "invidious";
      group = "invidious";
    };
    "invidious/po_token" = {
      owner = "invidious";
      group = "invidious";
    };
    "invidious/visitor_data" = {
      owner = "invidious";
      group = "invidious";
    };
  };

  sops.templates."invidious_secrets.json" = {
    content = ''
      		  { "hmac_key": "${config.sops.placeholder."invidious/hmac_key"}" }
      		  { "po_token": "${config.sops.placeholder."invidious/po_token"}" }
      		  { "visitor_data": "${config.sops.placeholder."invidious/visitor_data"}" }
      		'';
    mode = "0400";
    owner = "invidious";
    group = "invidious";
  };

  #sops.templates."invidious_hmac_key.json" = {
  #  content = ''{ "hmac_key": "${config.sops.placeholder."invidious/hmac_key"}" }'';
  #  mode = "0400";
  #	owner = "invidious";
  #	group = "invidious";
  #};
}
