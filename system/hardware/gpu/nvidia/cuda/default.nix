{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # TODO REPLACE LATER
  environment.systemPackages = [ pkgs.cudaPackages.cudatoolkit ];

  #nixpkgs.config.cudaSupport = true; # Causes some knarly rebuils

  hardware.nvidia-container-toolkit.enable = true;

  services.ollama.acceleration = "cuda";
}
