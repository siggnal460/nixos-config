{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ffmpeg
    pkgs.realesrgan-ncnn-vulkan
  ];
}
