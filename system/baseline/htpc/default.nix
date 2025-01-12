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

  hardware.graphics.enable = true;

  services.cage = {
    enable = true;
    user = "kodi";
    program = "${
      pkgs.kodi-wayland.passthru.withPackages (
        kodiPkgs: with kodiPkgs; [
          jellyfin
          keymap
          invidious
          sponsorblock
        ]
      )
    }/bin/kodi-standalone";
  };
}
