{ config, ... }:
{
  users.users.testuser = {
    uid = 1001;
    ignoreShellProgramCheck = true;
    createHome = true;
    isNormalUser = true;
    initialPassword = "testuser";
    extraGroups = [ "nix-users" ];
  };

  users.groups.testuser = {
    gid = config.users.users.testuser.uid;
    members = [ "testuser" ];
  };

  # Intentionally blank - verifies the config applies sane defaults to a
  # user with no home-manager customization of their own.
  home-manager.users.testuser = {
    home = {
      username = "testuser";
      homeDirectory = "/home/testuser";
      stateVersion = "23.11";
    };
  };
}
