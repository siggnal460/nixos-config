{
  systemd.user.tmpfiles.rules = [
    "d /home/aaron/Games 0700 aaron aaron"
    "L+ /home/aaron/Games/steam - - - - /home/aaron/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/common"
    "L+ /home/aaron/Games/roms - - - - /nfs/games"
  ];
}
