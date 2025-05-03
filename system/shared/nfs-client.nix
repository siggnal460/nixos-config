{
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

  systemd.tmpfiles.rules = [
    "d /mnt 0770 root users"
    "d /mnt/ai 0770 root ai"
    "d /mnt/blender 0770 root users"
    "d /mnt/media 0770 root media"
    "d /mnt/emulatorjs 0770 root wheel"
  ];

  fileSystems."/mnt/ai" = {
    device = "x86-atxtwr-computeserver:/export/ai";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
  fileSystems."/mnt/blender" = {
    device = "x86-atxtwr-computeserver:/export/blender";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
  fileSystems."/mnt/media" = {
    device = "x86-rakmnt-mediaserver:/export/media";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
  fileSystems."/mnt/emulatorjs" = {
    device = "x86-rakmnt-mediaserver:/export/emulatorjs";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "_netdev"
    ];
  };
}
