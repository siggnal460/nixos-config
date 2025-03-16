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
                  import auth

        			    reverse_proxy x86-merkat-auth:${toString ldap_cfg.settings.http_port}
        			'';

      "media.${domain}".extraConfig = ''
        			    reverse_proxy x86-rakmnt-mediaserver:8096
        			'';

      "monitoring.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-merkat-auth:8090
        			'';

      "linkwarden.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-atxtwr-computeserver:3001
        			'';

      "requests.${domain}".extraConfig = ''
        			    reverse_proxy x86-rakmnt-mediaserver:5055
        			'';

      "roms.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-rakmnt-mediaserver:81
        			'';

      "books.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-rakmnt-mediaserver:25600
        			'';

      "textgen.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-atxtwr-computeserver:3000
        			'';

      "imagegen.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-atxtwr-computeserver:9091
        			'';

      "gitea.${domain}".extraConfig = ''
                  import auth

        			    reverse_proxy x86-atxtwr-computeserver:3003
        			'';

      "cloud.${domain}".extraConfig = ''
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
