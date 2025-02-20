{ inputs, ... }:
{
  imports = [
    ../../shared/quietboot.nix
    inputs.nixos-hardware.nixosModules.starlabs-starlite-i5
  ];
}
