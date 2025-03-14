{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # TODO REPLACE LATER
  environment.systemPackages = [ pkgs.cudaPackages.cudatoolkit ];

  nixpkgs.config.cudaSupport = true;

  hardware.nvidia-container-toolkit.enable = true;

  services.ollama.acceleration = "cuda";
}
