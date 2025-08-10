{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  environment = {
    systemPackages = with pkgs; [
      virtiofsd # for sharing folders w/ a virtual machine
    ];
  };
}
