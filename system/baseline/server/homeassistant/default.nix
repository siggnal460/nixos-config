{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ 8123 ];

  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
  ];

  services = {
    home-assistant = {
      enable = true;
      extraComponents = [
        "homeassistant_hardware"
        "esphome"
        "isal"
        "piper"
        "whisper"
        "wyoming"
        "zha"
      ];
      config = {
        default_config = { };
        # Add UI-defined configs to declaritive setup
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
      };
    };
  };
}
