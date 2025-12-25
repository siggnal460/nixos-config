{
  config,
  pkgs,
  lib,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
    "L+ ${config.services.home-assistant.configDir}/secrets.yaml - - - - /etc/home-assistant/secrets.yaml"
  ];

  services = {
    home-assistant = {
      enable = true;
      openFirewall = true;
      extraComponents = [
        "homeassistant_hardware"
        "esphome"
        "flux"
        "isal"
        "piper"
        "whisper"
        "wyoming"
        "zha"
      ];
      customComponents = [
        (pkgs.callPackage ./hass-oidc-auth/auth_oidc.nix { })
      ];
      config = {
        default_config = { };

        http = {
          use_x_forwarded_for = true;
          trusted_proxies = "192.168.1.5";
        };

        auth_oidc = {
          client_id = "!secret client_id";
          client_secret = "!secret client_secret";
          discovery_url = "https://auth.gappyland.org/.well-known/openid-configuration";
          display_name = "Authelia";
          roles = {
            admin = "admins";
          };
        };

        switch = {
          name = "Flux";
          platform = "flux";
          lights = [
            "light.third_reality_nightstand_lightbulb"
            "light.kitchen_counter"
            "light.dining_room"
            "light.living_room"
            "light.sengled_hallway_light"
            "light.hallway_bathroom"
            "light.master_bathroom"
            "light.master_bedroom"
          ];
          start_time = "6:45";
          stop_time = "21:00";
          start_colortemp = 6500;
          stop_colortemp = 2200;
          disable_brightness_adjust = true;
          transition = 14400;
        };

        # Add UI-defined configs to declaritive setup
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
      };
    };
  };

  environment.etc = {
    "home-assistant/secrets.yaml" = {
      source = lib.mkForce config.sops.templates.ha-secrets.path;
      user = "hass";
      group = "hass";
      mode = "0400";
    };
  };

  sops.templates.ha-secrets = {
    owner = "hass";
    file = (pkgs.formats.yaml { }).generate "yaml" {
      client_id = "${config.sops.placeholder."ha/oidc_client_id"}";
      client_secret = "${config.sops.placeholder."ha/oidc_client_secret"}";
    };
  };

  sops.secrets = {
    "ha/oidc_client_id".owner = "hass";
    "ha/oidc_client_secret".owner = "hass";
  };
}
