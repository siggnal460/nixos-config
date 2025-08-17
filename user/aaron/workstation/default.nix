{ ... }:
{
  users.users.aaron.extraGroups = [ "libvirtd" ];

  systemd.tmpfiles.rules = [
    "d /home/aaron/Blender 0700 aaron aaron"
    "d /home/aaron/Blender/addons 0700 aaron aaron"
    "d /home/aaron/Blender/models 0700 aaron aaron"
    "d /home/aaron/Blender/models/male 0700 aaron aaron"
    "d /home/aaron/Blender/models/female 0700 aaron aaron"
    "d /home/aaron/Blender/models/objects 0700 aaron aaron"
    "d /home/aaron/Blender/environments 0700 aaron aaron"
    "d /home/aaron/Projects 0700 aaron aaron"
    "d /home/aaron/Games 0700 aaron aaron"
    "L+ /home/aaron/Games/steam - - - - /home/aaron/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/common"
    "L+ /home/aaron/Games/gog - - - - /srv/games/gog"
    "L+ /home/aaron/Games/2ds - - - - /srv/games/roms/2ds"
    "L+ /home/aaron/Games/3ds - - - - /srv/games/roms/3ds"
    "L+ /home/aaron/Games/gb - - - - /srv/games/roms/gb"
    "L+ /home/aaron/Games/gbc - - - - /srv/games/roms/gbc"
    "L+ /home/aaron/Games/gba - - - - /srv/games/roms/gba"
    "L+ /home/aaron/Games/gc - - - - /srv/games/roms/gc"
    "L+ /home/aaron/Games/n64 - - - - /srv/games/roms/n64"
    "L+ /home/aaron/Games/nes - - - - /srv/games/roms/nes"
    "L+ /home/aaron/Games/ps1 - - - - /srv/games/roms/ps1"
    "L+ /home/aaron/Games/ps2 - - - - /srv/games/roms/ps2"
    "L+ /home/aaron/Games/ps3 - - - - /srv/games/roms/ps3"
    "L+ /home/aaron/Games/psp - - - - /srv/games/roms/psp"
    "L+ /home/aaron/Games/snex - - - - /srv/games/roms/snes"
    "L+ /home/aaron/Games/wii - - - - /srv/games/roms/wii"
    "L+ /home/aaron/Games/wiiu - - - - /srv/games/roms/wiiu"
  ];

  home-manager.users.aaron = {
    imports = [
      ./programs/mpv
      ./programs/librewolf
      ./programs/hyprland
      ./programs/mangohud
    ];

    accounts.email.accounts.aaron.thunderbird.enable = true;

    programs.wezterm.enable = true;

    dconf.settings = {
      # connects virt-manager to qemu
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    fonts.fontconfig.enable = true;
  };
}
