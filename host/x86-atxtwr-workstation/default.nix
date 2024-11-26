{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  #  boot.kernelParams = [ #maybe not needed
  #    "video=DP-1:2560x1440@240"
  #    "video=DP-3:1920x1080@144"
  #  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
    }
  ];

  networking = {
    hostName = "x86-atxtwr-workstation";
    #interfaces.enp7s0 = {
    #useDHCP = false;
    #ipv4.addresses = [{
    #address = "10.6.0.1";
    #prefixLength = 12;
    #}];
    #};
  };

  fileSystems."/mnt/extra-drives" = {
    device = "/dev/disk/by-uuid/cf89934f-6d10-4b52-965a-55f65ae7dd96";
    fsType = "ext4";
  };

  services.ratbagd.enable = true;

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };
}
