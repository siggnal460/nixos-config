{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.pkgs.linuxPackages_latest;
  };
}
