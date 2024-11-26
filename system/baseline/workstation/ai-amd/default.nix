{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
    };
    rocmOverrideGfx = "11.0.0";
  };
}
