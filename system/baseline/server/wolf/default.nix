{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    "d /etc/wolf 0770 wolf wheel"
  ];

  users = {
    users = {
      wolf = {
        uid = 770;
        isSystemUser = true;
        group = "wolf";
      };
    };
    groups = {
      wolf = {
        gid = 770;
      };
    };
  };

  virtualisation.oci-containers.containers = {
    wolf = {
      image = "ghcr.io/games-on-whales/wolf:stable";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "47984/tcp"
        "47989/tcp"
        "47999/udp"
        "48010/tcp"
        "48100-48110/udp"
        "48200-48210/udp"
      ];
      environment = {
        XDG_RUNTIME_DIR = "/tmp/sockets";
        HOST_APPS_STATE_FOLDER = "/etc/wolf";
        PUID = "700";
        PGID = "982";
        TZ = "America/Denver";
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NVIDIA_VISIBLE_DEVICES = "all";
      };
      volumes = [
        "/etc/wolf:/etc/wolf"
        "/tmp/sockets:/tmp/sockets:rw"
        "/var/run/docker.sock:/var/run/docker.sock:rw"
        "/dev/:/dev/:rw"
        "/run/udev:/run/udev:rw"
      ];
      devices = [
        "/dev/dri/"
        "/dev/uinput"
        "/dev/uhid"
      ];
      extraOptions = [
        "--name=wolf"
        "--device-cgroup-rule=c 13:* rmw"
        "--gpus=all"
      ];
    };
  };
}
