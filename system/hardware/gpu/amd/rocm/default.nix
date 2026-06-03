{ pkgs, ... }:
{
  hardware.amdgpu.opencl.enable = true;
  nixpkgs.config.rocmSupport = true;
  services.ollama.package = pkgs.ollama-rocm;
}
