{ config, ... }:
{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    "d /var/lib/ipa-data 0774 freeipa freeipa"
  ];

  users.users = {
    freeipa = {
      uid = 800;
      isSystemUser = true;
      group = "freeipa";
    };
  };

  users.groups = {
    freeipa = {
      gid = 800;
    };
  };

  virtualisation.oci-containers.containers = {
    freeipa = {
      image = "docker.io/freeipa/freeipa-server:almalinux-9";
      autoStart = true;
      hostname = "${config.networking.fqdn}";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "53:53"
        "53:53/udp"
        "81:80"
        "88:88"
        "88:88/udp"
        "123:123"
        "389:389"
        "444:443"
        "464:464"
        "464:464/udp"
        "636:636"
      ];
      environment = {
        PUID = "800";
        PGID = "800";
        IPA_SERVER_IP = "10.0.0.11"; # fix later
        PASSWORD = "justatest";
        DEBUG_TRACE = "1";
        DEBUG_NO_EXIT = "1";
      };
      volumes = [
        "/var/lib/ipa-data:/data"
      ];
      extraOptions = [
        "--name=freeipa"
        "--read-only"
        #"--dns=127.0.0.1"
      ];
      cmd = [
        "-U"
        "-r"
        "GAPPYLAND.ORG"
        #"-p GAPPYLAND.ORG"
        #"-a GAPPYLAND.ORG"
        "--no-ntp"
      ];
    };
  };
}
