{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/htpc
  ];

  networking = {
    hostName = "x86-merkat-workout";
  };

  hardware.system76.enableAll = true;
}
