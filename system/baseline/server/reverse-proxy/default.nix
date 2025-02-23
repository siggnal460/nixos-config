{ config, pkgs, ... }:
let
  htmlFile = ./files/index.html;
  domain = "gappyland.org";
  ldap_cfg = config.services.lldap;
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      ${domain}.extraConfig = ''
                          					encode gzip
                          					file_server
        														reverse_proxy :8082
                			'';

      "auth.${domain}".extraConfig = ''
        			    reverse_proxy x86-merkat-auth:9091
        			'';

      "users.${domain}".extraConfig = ''
        			    reverse_proxy x86-merkat-auth:${toString ldap_cfg.settings.http_port}
        			'';

      "media.${domain}".extraConfig = ''
                  redir /jellyfin /jellyfin/
        			    reverse_proxy /jellyfin/* x86-rakmnt-mediaserver:8096
        			'';

      "monitoring.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-merkat-auth:8090
        			'';

      "jellyseerr.${domain}".extraConfig = ''
        			    reverse_proxy x86-rakmnt-mediaserver:5055
        			'';

      "games.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-rakmnt-mediaserver:81
        			'';

      "books.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-rakmnt-mediaserver:25600
        			'';

      "nextcloud.${domain}".extraConfig = ''
                        			  import auth

                                reverse_proxy https://x86-rakmnt-mediaserver:443 {
        												  transport http {
        													  tls
        														tls_insecure_skip_verify
        													}
        												}
      '';
    };
    extraConfig = ''
      			(auth) {
      					forward_auth x86-merkat-auth:9091 {
      							uri /api/authz/forward-auth
      							copy_headers remote-user remote-groups remote-email remote-name
      					}
      			}
      		'';
  };
}
