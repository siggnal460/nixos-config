{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/htpc
  ];

  networking = {
    hostName = "x86-merkat-bedhtpc";
  };

  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 3;
    }
  ];
}
