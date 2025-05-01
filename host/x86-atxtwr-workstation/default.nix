{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  stylix = {
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
    }
  ];

  services.ollama = {
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
    };
    rocmOverrideGfx = "11.0.0";
  };

  networking = {
    hostName = "x86-atxtwr-workstation";
    interfaces.enp5s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.0.0.15";
          prefixLength = 12;
        }
      ];
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "enp5s0";
    };
  };

  fileSystems."/mnt/extra-drives" = {
    device = "/dev/disk/by-uuid/cf89934f-6d10-4b52-965a-55f65ae7dd96";
    fsType = "ext4";
  };

  boot.tmp.tmpfsSize = "95%";

  services.ratbagd.enable = true;

  systemd.tpm2.enable = false;

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };
}
