{
  systemd.user.tmpfiles.rules = [
    "d /home/aaron/Games 0700 aaron aaron"
    "L+ /home/aaron/Games/retro - - - - /srv/games"
  ];
}
