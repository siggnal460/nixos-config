{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.pkgs.linuxPackages_latest;
  };
}
