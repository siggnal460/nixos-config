{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
    };
  };

  networking.hostId = "bda395e9";

  services.zfs.autoScrub = {
    enable = true;
    interval = "*-*-1,15 02:30";
  };

  services.sanoid = {
    enable = true;
    templates.backup = {
      hourly = 36;
      daily = 30;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };

    datasets."zfspool/media" = {
      useTemplate = [ "backup" ];
    };
  };

  networking = {
    hostName = "x86-rakmnt-mediaserver";
    #interface.eth0.ipv4.addresses = [{
    #  address = "10.4.0.1";
    #  prefixLength = 12;
    #}];
  };
}
