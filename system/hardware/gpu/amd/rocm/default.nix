{
  hardware.amdgpu.opencl.enable = true;
  nixpkgs.config.rocmSupport = true;
  services.ollama.acceleration = "rocm";
}
