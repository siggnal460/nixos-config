{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/workstation
    ../../user/aaron/host/x86-atxtwr-workstation
    ../../user/testuser
  ];

  networking = {
    hostName = "x86-atxtwr-workstation";
  };

  services.ratbagd.enable = true;

  # Credentials for the opnsense MCP server (.mcp.json)
  sops.secrets."api_key" = {
    sopsFile = ../../secrets/opnsense-mcp/secrets.yaml;
    mode = "0444";
  };
  sops.secrets."api_secret" = {
    sopsFile = ../../secrets/opnsense-mcp/secrets.yaml;
    mode = "0444";
  };

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
      (writeShellScriptBin "opnsense-mcp-launch" ''
        export OPNSENSE_API_KEY="$(cat ${config.sops.secrets."api_key".path})"
        export OPNSENSE_API_SECRET="$(cat ${config.sops.secrets."api_secret".path})"
        exec ${pkgs.nodejs}/bin/npx -y @richard-stovall/opnsense-mcp-server
      '')
    ];
  };

  systemd.services.flatpak-host-tweaks = {
    wantedBy = [ "multi-user.target" ];
    requires = [ "flatpak-gaming-setup.service" ];
    path = [ pkgs.flatpak ];
    script = ''
            flatpak override --env=DXVK_FRAME_RATE=240 com.valvesoftware.Steam && \
      			  echo "Setting max framerate for DXVK"
    '';
  };
}
