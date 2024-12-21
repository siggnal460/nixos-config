{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
    };
  };

  networking = {
    hostId = "bda395e9";
    hostName = "x86-atxtwr-workstation";
    interfaces.enp42s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.0.0.7";
          prefixLength = 12;
        }
      ];
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "enp4s0";
    };
  };

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
}
