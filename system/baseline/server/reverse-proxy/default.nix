{ pkgs, ... }:
let
  htmlFile = ./files/index.html;
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      "gappyland.org" = {
        extraConfig = ''
          					encode gzip
          					file_server
          					root * ${
                 pkgs.runCommand "populateCaddyHtml" { } ''
                           mkdir "$out"
                   				echo "${builtins.readFile htmlFile}" > "$out/index.html"
                             				''
               }
          					'';
      };
      "media.gappyland.org" = {
        extraConfig = ''
          				  reverse_proxy /jellyfin* 10.0.0.7:8096
          				'';
      };
    };
  };
}
