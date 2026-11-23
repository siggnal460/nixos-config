{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/workstation
    ../../user/aaron/host/x86-laptop-galago
  ];

  # Credentials for the opnsense MCP server (.mcp.json) — same shared secret
  # as opentofu/OPNsense.internal/x86-atxtwr-workstation, decrypted
  # system-wide here too so this laptop can also run the MCP server.
  sops.secrets."api_key" = {
    sopsFile = ../../secrets/opnsense-mcp/secrets.yaml;
    mode = "0444";
  };
  sops.secrets."api_secret" = {
    sopsFile = ../../secrets/opnsense-mcp/secrets.yaml;
    mode = "0444";
  };

  stylix = {
    base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };

  networking = {
    hostName = "x86-laptop-galago";
    /*
      interfaces.enp36s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.2.0.1";
          prefixLength = 12;
        }];
      };
      interfaces.enp4s0u1u3u3 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.2.0.1";
          prefixLength = 12;
        }];
      };
      #priorities per network interface, lower is more preferred
      dhcpcd.extraConfig = ''
      interface enp36s0
      metric 1

      interface enp4s0u1u3u3
      metric 2

      interface wlp0s20f3
      metric 3
      '';
    */
  };

  /*
    This doesn't work I guess?
    home-manager.users.aaron = {
      wayland.windowManager.hyprland.extraConfig = ''
        monitor = eDP-1,1920x1080@144,1300x-1080,1.25
        monitor = DP-2,1920x1080@143.981,1920x0,1
        monitor = DP-7,1920x1080@143.981,0x0,1
        '';
    };
  */

  services.ratbagd.enable = true;

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
}
