#let
#	caddyDir = "/containers/caddy";
#	caddyFiles = "/etc/nixos/system/baseline/server/reverse-proxy/files";
#in {
{
  #  systemd.tmpfiles.rules = [
  #    "d /containers 0775 root root"
  #    "d ${caddyDir}/etc 0770 caddy caddy"
  #    "L+ ${caddyDir}/etc/Caddyfile 0777 caddy caddy - ${caddyFiles}/Caddyfile"
  #    "d ${caddyDir}/data 0770 caddy caddy" "d ${caddyDir}/config 0770 caddy caddy"
  #    "d ${caddyDir}/share 0770 caddy caddy"
  #    "L+ ${caddyDir}/share/index.html 0777 caddy caddy - ${caddyFiles}/index.html"
  #    "d ${caddyDir}/site 0770 caddy caddy"
  #	];
  #
  #  users.users = {
  #    caddy = {
  #      uid = 700;
  #      isSystemUser = true;
  #      group = "caddy";
  #    };
  #  };
  #
  #  users.groups.caddy = {
  #    gid = 700;
  #  };
  #
  #  virtualisation.oci-containers.containers = {
  #    caddy = {
  #      image = "docker.io/caddy/caddy:latest";
  #      autoStart = true;
  #      labels = {
  #        "io.containers.autoupdate" = "registry";
  #      };
  #      environment = {
  #        PUID = "700";
  #        PGID = "700";
  #			};
  #      ports = [
  #			  "80:80"
  #				"443:443"
  #				"443:443/udp"
  #			];
  #      volumes = [
  #			  "${caddyDir}/etc/Caddyfile:/etc/caddy/Caddyfile"
  #				"${caddyDir}/data:/data"
  #				"${caddyDir}/config:/config"
  #			  "${caddyDir}/share/index.html:/usr/share/caddy/index.html"
  #			  "${caddyDir}/site:/srv"
  #      ];
  #      extraOptions = [
  #        "--cap-add=NET_ADMIN"
  #			];
  #    };
  #	};
}
