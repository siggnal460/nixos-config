{
  programs.git = {
    enable = true;
    userName = "siggnal460";
    userEmail = "siggnal@proton.me";
    ignores = [
      "*~"
      "*.swp"
    ];
    extraConfig = {
      init.defaultBranch = "master";
      safe.directory = "/etc/nixos";
    };
  };
}
