{ config, ... }:
let
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
        			  import main
        				import headers

                reverse_proxy x86-merkat-auth:9091
      '';

      "users.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

                reverse_proxy x86-merkat-auth:${toString ldap_cfg.settings.http_port}
      '';

      "media.${domain}".extraConfig = ''
        			  import main
        				import headers

                reverse_proxy x86-rakmnt-mediaserver:8096
      '';

      "monitoring.${domain}".extraConfig = ''
                import auth
        			  import main
        				import headers

                reverse_proxy x86-merkat-auth:8090
      '';

      "requests.${domain}".extraConfig = ''
        			  import main
        				import headers

                reverse_proxy x86-rakmnt-mediaserver:5055
      '';

      "roms.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

                reverse_proxy x86-rakmnt-mediaserver:81
      '';

      "books.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

                reverse_proxy x86-rakmnt-mediaserver:25600
      '';

      "textgen.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

                reverse_proxy x86-atxtwr-computeserver:3000
      '';

      "imagegen.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

                reverse_proxy x86-atxtwr-computeserver:9091
      '';

      "gitea.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

                reverse_proxy x86-atxtwr-computeserver:3003
      '';

      "home.${domain}".extraConfig = ''
        				import main
                import auth
        				import headers

                reverse_proxy arm-raspi4-home:8123
      '';

      "recipes.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

        			  header Host $http_host
        			  header X-Forwarded-Proto $scheme;

        				handle_path /media/* {
        					root * /www/tandoor
        					file_server
        				}

                reverse_proxy x86-rakmnt-mediaserver:5413
      '';

      "cloud.${domain}".extraConfig = ''
        			  import main
                import auth
        				import headers

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

      				(main) {
      					
      					respond /robots.txt 200 {
      						body "User-agent: *
      						Disallow: /
      						
      						User-agent: AdsBot-Google
      						Disallow: /

      						User-agent: AdsBot-Google-Mobile
      						Disallow: /"

      						close
      					}
      				}

      				(headers) {
      					header {
      						-server #anonymizes Caddy

      						# disable FLoC tracking
      						Permissions-Policy interest-cohort=()

      						# enable HSTS
      						Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"

      						X-Content-Type-Options "nosniff" # disable clients from sniffing the media type

      						# clickjacking protection
      						X-Frame-Options DENY
      					}
      				}
    '';
  };
}
