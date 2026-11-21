{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
  ];

  networking = {
    hostName = "x86-merkat-entry";
    domain = "gappyland.org";
  };
}
