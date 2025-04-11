{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-merkat-entry";
    domain = "gappyland.org";
  };
}
