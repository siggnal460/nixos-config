{ lib, inputs, ... }:
{
  imports = [
    inputs.jovian-nixos.nixosModules.default
    ../../shared/latest-kernel.nix
    ../../shared/plymouth.nix
    ../../shared/plymouth-delay.nix
    ../../shared/quietboot.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
    #../../shared/mesa-git.nix
  ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam-jupiter-original"
        "steamdeck-hw-theme"
      ];
  };

  jovian = {
    decky-loader = {
      enable = true;
    };
    steam = {
      enable = true;
      autoStart = true;
    };
    hardware.has.amd.gpu = true;
  };

  xdg.autostart.enable = true;
}