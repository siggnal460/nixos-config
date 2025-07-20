{ lib, ... }:
let
  mountOptions = [
    "x-systemd.automount"
		"noauto"
		"x-systemd.idle-timeout=60"
    "_netdev"
	];
in
{
  systemd.tmpfiles.rules = [
    "d /etc/deluge 0750 deluge wheel"
    "d /nfs/media 0774 root root"
    "d /nfs/media/torrents 0770 deluge media"
    "d /nfs/media/torrents/complete 0770 deluge media"
    "d /nfs/media/torrents/complete/anime 0770 deluge media"
    "d /nfs/media/torrents/complete/anime-movies 0770 deluge media"
    "d /nfs/media/torrents/complete/books 0770 deluge media"
    "d /nfs/media/torrents/complete/tvshows 0770 deluge media"
    "d /nfs/media/torrents/complete/movies 0770 deluge media"
    "d /nfs/media/torrents/incomplete 0770 deluge media"
  ];

  imports = [
	  ../../../shared/podman.nix
	  ../../../shared/nfs-client.nix
	];

  networking.firewall = { # remember to enable port forwarding in router
	  allowedTCPPorts = [ 49154 ];
    allowedUDPPorts = [ 49154 ];
	};

  fileSystems."/nfs/media" = {
    device = lib.mkForce "x86-rakmnt-mediaserver:/export/media";
    fsType = lib.mkForce "nfs4";
    options = mountOptions;
  };

  users.users = {
    deluge = {
      uid = 710;
      isSystemUser = true;
      group = "media";
    };
  };

  virtualisation.oci-containers.containers = {
    deluge = {
      image = "lscr.io/linuxserver/deluge:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8112:8112"
        "49154:6881"
        "49154:6881/udp"
      ];
      environment = {
        PUID = "710";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/torrents:/downloads"
        "/etc/deluge:/config"
      ];
      extraOptions = [
        "--name=deluge"
      ];
    };
  };
}
