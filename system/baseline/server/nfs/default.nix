{
  systemd.tmpfiles.rules = [ "d /export 0775 root root" ];

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
