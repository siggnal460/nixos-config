{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-merkat-entry";
    domain = "gappyland.org";
  };

  beszel-agent.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXz3a6nV8xxYD5tomKiPul/RTuaAK2s51cGzxgv/X1s";
}
