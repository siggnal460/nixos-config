{
  home-manager.users.aaron = {
    imports = [
      ./programs/mangohud
      ../shared/gaming.nix
    ];
  };

  jovian = {
    decky-loader.user = "aaron";
    steam.user = "aaron";
  };
}
