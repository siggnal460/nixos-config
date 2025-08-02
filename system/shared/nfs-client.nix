{ lib, ... }:
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

  services.rpcbind.enable = lib.mkForce false; # unnecessary for NFSv4.
}
