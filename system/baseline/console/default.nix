{ lib, ... }:
{
  imports = [
    ../../shared/plymouth.nix
    ../../shared/plymouth-delay.nix
    ../../shared/quietboot.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
    ../../shared/networkmanager.nix
  ];

  networking.networkmanager.enable = true;

  nixpkgs.allowUnfreePackages = [
    "steam"
    "steam-jupiter-original"
    "steamdeck-hw-theme"
    "steam-jupiter-unwrapped"
  ];

  jovian = {
    steamos.useSteamOSConfig = true;
    decky-loader = {
      enable = true;
    };
    steam = {
      desktopSession = "cosmic";
      enable = true;
      autoStart = true;
      user = "aaron";
    };
  };

  services.displayManager.cosmic-greeter.enable = lib.mkForce false;

  xdg.autostart.enable = true;
}
