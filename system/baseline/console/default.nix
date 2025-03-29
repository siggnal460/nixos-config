{ lib, ... }:
{
  imports = [
    ../../shared/latest-kernel.nix
    ../../shared/plymouth.nix
    ../../shared/plymouth-delay.nix
    ../../shared/quietboot.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
    ../../shared/networkmanager.nix
  ];

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
      user = "aaron";
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
