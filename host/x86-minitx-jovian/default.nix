{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  #nixpkgs.config.allowBroken = true;

  boot = {
    #kernelPackages = lib.mkForce pkgs.pkgs.linuxPackages;
    #extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
    #kernelPackages = pkgs.linuxKernel.packages.linux_6_8.r8125;
    #kernelParams = [
    #  "video=HDMI-A-1:3840x2160@120"
    #];
  };

  networking = {
    hostName = "x86-minitx-jovian";
    #   interface.eth0.ipv4.addresses = [ {
    #     address = "10.6.0.1";
  };
}
