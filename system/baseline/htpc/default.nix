{ pkgs, ... }:
{
  imports = [
    ../../shared/plymouth.nix
    ../../shared/plymouth-delay.nix
    ../../shared/quietboot.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
  ];

  users.extraUsers.kodi.isNormalUser = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Configures wayland kiosk running kodi
  services.cage = {
    enable = true;
    user = "kodi";
    program = "${
      pkgs.kodi-wayland.passthru.withPackages (
        kodiPkgs: with kodiPkgs; [
          invidious
          jellyfin
          joystick
          steam-library
        ]
      )
    }/bin/kodi-standalone";
  };
}
