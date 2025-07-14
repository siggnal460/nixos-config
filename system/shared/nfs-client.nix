{ lib, ... }:
let
  mountOptions = [
	  #"bg"
		#"intr"
		#"hard"
		#"retrans=1"
		#"retry=0"
		#"timeo=30"
    "x-systemd.automount"
		"noauto"
		"x-systemd.idle-timeout=60"
    "_netdev"
	];
in
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
    "d /nfs 0770 root users"
    "d /nfs/ai 0770 root ai"
    "d /nfs/blender 0770 root users"
    "d /nfs/media 0770 root media"
    "d /nfs/emulatorjs 0770 root wheel"
  ];

  fileSystems."/nfs/ai" = {
    device = lib.mkForce "x86-atxtwr-computeserver:/export/ai";
    fsType = lib.mkForce "nfs4";
    options = mountOptions;
  };
  fileSystems."/nfs/blender" = {
    device = lib.mkForce "x86-atxtwr-computeserver:/export/blender";
    fsType = lib.mkForce "nfs4";
    options = mountOptions;
  };
  fileSystems."/nfs/media" = {
    device = lib.mkForce "x86-rakmnt-mediaserver:/export/media";
    fsType = lib.mkForce "nfs4";
    options = mountOptions;
  };
  fileSystems."/nfs/emulatorjs" = {
    device = lib.mkForce "x86-rakmnt-mediaserver:/export/emulatorjs";
    fsType = lib.mkForce "nfs4";
    options = mountOptions;
  };
}
