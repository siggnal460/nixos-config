{ config, pkgs, ... }:
let
  htmlFile = ./files/index.html;
  domain = "gappyland.org";
  ldap_cfg = config.services.lldap;
in
{
  networking.firewall.allowedTCPPorts = [
    443
  ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      ${domain}.extraConfig = ''
                  					encode gzip
                  					file_server
                  					root * ${
                         pkgs.runCommand "populateCaddyHtml" { } ''
                           							mkdir "$out"
                           							echo "${builtins.readFile htmlFile}" > "$out/index.html"
                           						''
                       }
        			'';

      "auth.${domain}".extraConfig = ''
        			    reverse_proxy :9091
        			'';

      "users.${domain}".extraConfig = ''
        			    reverse_proxy :${toString ldap_cfg.settings.http_port}
        			'';

      "media.${domain}".extraConfig = ''
                  redir /jellyfin /jellyfin/
        			    reverse_proxy /jellyfin/* x86-rakmnt-mediaserver:8096
        			'';

      "nextcloud.${domain}".extraConfig = ''
                			  import auth

                        reverse_proxy x86-rakmnt-mediaserver:80 {
                				  transport http {
                					  tls_insecure_skip_verify
                					}
        								}
      '';
    };
    extraConfig = ''
      			(auth) {
      					forward_auth :9091 {
      							uri /api/authz/forward-auth
      							copy_headers remote-user remote-groups remote-email remote-name
      					}
      			}
      		'';
  };
}
