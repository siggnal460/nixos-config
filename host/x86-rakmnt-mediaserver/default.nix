{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-racmnt-mediaserv";
    #interface.eth0.ipv4.addresses = [{
    #  address = "10.4.0.1";
    #  prefixLength = 12;
    #}];
  };
}
