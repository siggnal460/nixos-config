{ lib, allowed-unfree-packages, ... }:
{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  };

  hardware.nvidia.prime = {
    allowExternalGpu = true;
    offload.enable = true;
    nvidiaBusId = "PCI:0:2:0";
    intelBusId = "PCI:47:0:0";
  };
}
