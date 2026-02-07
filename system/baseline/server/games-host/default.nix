{
  users.groups = {
    games = {
      gid = 770;
    };
  };

  systemd.tmpfiles.rules = [
    "d /export/games 0775 root games"
    "d /export/games/bios 0775 root games"
    "d /export/games/gog 0775 root games"
    "d /export/games/roms 0775 root games"
    "d /export/games/roms/2ds 0775 root games"
    "d /export/games/roms/3ds 0775 root games"
    "d /export/games/roms/gb 0775 root games"
    "d /export/games/roms/gbc 0775 root games"
    "d /export/games/roms/gba 0775 root games"
    "d /export/games/roms/gc 0775 root games"
    "d /export/games/roms/n64 0775 root games"
    "d /export/games/roms/nes 0775 root games"
    "d /export/games/roms/ps1 0775 root games"
    "d /export/games/roms/ps2 0775 root games"
    "d /export/games/roms/ps3 0775 root games"
    "d /export/games/roms/psp 0775 root games"
    "d /export/games/roms/snes 0775 root games"
    "d /export/games/roms/wii 0775 root games"
    "d /export/games/roms/wiiu 0775 root games"
  ];

  services.nfs.server = {
    exports = "/export/games 192.168.0.0/20(rw,nohide,insecure,no_subtree_check)";
  };
}
