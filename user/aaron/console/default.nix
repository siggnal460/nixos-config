{
  home-manager.users.aaron = {
    imports = [ ./programs/mangohud ];
  };

  jovian = {
    decky-loader.user = "aaron";
    steam.user = "aaron";
  };
}
