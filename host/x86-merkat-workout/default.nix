{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-merkat-workout";
  };

  hardware.system76.enableAll = true;
}
