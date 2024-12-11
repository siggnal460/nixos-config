{
  systemd.tmpfiles.rules = [ "d /export/blender 0770 root users" ];

  networking.firewall.allowedTCPPorts = [ 8642 ];

  services.nfs.server = {
    exports = ''/export/blender 10.0.0.10/12(rw,sync,no_subtree_check,insecure,nohide)'';
  };
}
