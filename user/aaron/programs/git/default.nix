{
  programs.git = {
    enable = true;
    ignores = [
      "*~"
      "*.swp"
    ];
    settings = {
      user.name = "siggnal460";
      user.email = "siggnal@proton.me";
      init.defaultBranch = "master";
      safe.directory = "/etc/nixos";
    };
  };
}
