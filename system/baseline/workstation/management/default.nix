{
  imports = [
    ../../../../user/claude
  ];

  systemd = {
    tmpfiles.rules = [
      "A /etc/nixos - - - - group:agents:rwX,default:group:agents:rwX"
    ];
  };

  users.groups.agents = {
    gid = 1100;
    members = [ "claude" ];
  };
}
