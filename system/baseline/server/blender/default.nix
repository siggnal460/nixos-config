{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /export/blender 0770 root users"
    "d /export/blender/add-ons 0770 root users"
    "d /export/blender/models 0770 root users"
    "d /export/blender/projects 0770 root users"
    "d /export/blender/renders 0770 root users"
    "d /export/blender/reference 0770 root users"
  ];

  services.nfs.server = {
    exports = "/export/blender x86-atxtwr-workstation(rw,sync,no_subtree_check,insecure,nohide)";
  };

  environment.systemPackages = [ (pkgs.blender.override { cudaSupport = true; }) ];
}
