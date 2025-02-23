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
      "/mnt/media" = {
        d = {
          mode = "0770";
          user = "root";
          group = "users";
        };
      };
      "/mnt/emulatorjs" = {
        d = {
          mode = "0770";
          user = "root";
          group = "users";
        };
      };
    };
  };

  boot.initrd = {
    supportedFilesystems = [
      "nfs"
      "nfs4"
    ];
    kernelModules = [
      "nfs"
      "nfs4"
    ];
  };

  fileSystems."/mnt/ai" = {
    device = "10.0.0.10:/export/ai";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
  fileSystems."/mnt/blender" = {
    device = "10.0.0.10:/export/blender";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
  fileSystems."/mnt/media" = {
    device = "10.0.0.7:/export/media";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
  fileSystems."/mnt/emulatorjs" = {
    device = "10.0.0.7:/export/emulatorjs";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
}
