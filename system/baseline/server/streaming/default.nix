{
  users.groups = {
    owncast = { };
  };

  users.users = {
    owncast = {
      group = "owncast";
      createHome = false;
      isSystemUser = true;
    };
  };

  services.owncast = {
    enable = true;
    openFirewall = true;
    user = "owncast";
    group = "owncast";
  };
}
