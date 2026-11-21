{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/workstation
  ];

  networking = {
    hostName = "x86-tablet-starlite";
  };
}
