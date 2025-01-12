{ pkgs, ... }:

{
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
      vpl-gpu-rt # QVL
    ];
  };
}
