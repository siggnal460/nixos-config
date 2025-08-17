{ lib, ... }:
let
  mountOptions = [
    "x-systemd.automount"
    "x-systemd.device-timeout=2s"
    "x-systemd.mount-timeout=2s"
    "x-systemd.idle-timeout=600" # 10min
    "bg"
    "noauto"
    "nofail"
  ];
in
{
  imports = [
    ../../../shared/podman.nix
    ../../../shared/nfs-client.nix
  ];

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
        "6881:6881" # forward 6881 in the router
        "6881:6881/udp"
      ];
      environment = {
        PUID = "710";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/nfs/media/torrents:/downloads"
        "/etc/deluge:/config"
      ];
      extraOptions = [
        "--name=deluge"
      ];
    };
  };
}
