{
  boot.initrd.systemd.tmpfiles.settings = {
    "10-nfs-mounts" = {
      "/mnt/ai" = {
        d = {
          mode = "0770";
          user = "root";
          group = "users";
        };
      };
      "/mnt/blender" = {
        d = {
          mode = "0770";
          user = "root";
          group = "users";
        };
      };
    };
  };

  # NOTE I had to manually run sudo modprobe nfs despite this config
  boot.initrd = {
    supportedFilesystems = [
      "nfs"
      "nfs4"
    ];
    kernelModules = [ "nfs" ];
  };

  fileSystems."/mnt/ai" = {
    device = "10.0.0.11:/export/ai";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
  fileSystems."/mnt/blender" = {
    device = "10.0.0.11:/export/blender";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
}