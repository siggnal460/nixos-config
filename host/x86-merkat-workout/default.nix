{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-merkat-lrhtpc";
  };

  hardware.system76.enableAll = true;
}
