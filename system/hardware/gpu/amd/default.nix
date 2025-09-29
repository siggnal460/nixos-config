# For use with an AMD GPU
{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];

  # for xwayland?
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  environment.systemPackages = with pkgs; [ lact ];
}
