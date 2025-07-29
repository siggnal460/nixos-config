{
  boot.initrd = {
    supportedFilesystems = [
      "nfs4"
    ];
    kernelModules = [
      "nfs4"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /nfs 0775 root users"
  ];
}
