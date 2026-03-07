{ pkgs, ... }:
{
  # WHY DOESN'T THIS WORK??
  #nixpkgs.config = {
  #  allowUnfreePredicate =
  #    pkg:
  #    builtins.elem (lib.getName pkg) [
  #      "cuda_cudart"
  #    ];
  #};

  nixpkgs.config.allowUnfree = true;

  # TODO REPLACE LATER
  environment.systemPackages = [ pkgs.cudaPackages.cudatoolkit ];

  # nixpkgs.config.cudaSupport = true; # could cause some knarly rebuilds

  hardware.nvidia-container-toolkit.enable = true;

  #services.ollama.package = pkgs.ollama-cuda;
}
