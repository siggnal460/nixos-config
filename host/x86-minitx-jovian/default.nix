{
  imports = [
    ./hardware-configuration.nix
    ../../system/shared/plymouth-tv.nix
  ];

  boot = {
    #kernelPackages = lib.mkForce pkgs.pkgs.linuxPackages;
    #extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
    #kernelPackages = pkgs.linuxKernel.packages.linux_6_8.r8125;
    #kernelParams = [
    #  "video=HDMI-A-1:3840x2160@120"
    #];
  };

  networking = {
    hostName = "x86-minitx-jovian";
  };

  jovian.hardware = {
    has.amd.gpu = true;
    amd.gpu.enableBacklightControl = false;
    steamdeck.enable = false;
  };
}
