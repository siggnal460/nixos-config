{
  boot.initrd.systemd.tmpfiles.settings = {
    "10-nfs-exports" = {
      "/export" = {
        d = {
          mode = "0664";
          user = "root";
          group = "root";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];

  services = {
    nfs = {
      server = {
        enable = true;
      };
      settings = {
        nfsd.vers = 4.2;
      };
    };
  };
}
