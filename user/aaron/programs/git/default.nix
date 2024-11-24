{
  programs.git = {
    enable = true;
    userName = "siggnal";
    userEmail = "siggnal@proton.me";
    ignores = [
      "*~"
      "*.swp"
    ];
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = "true";
    };
  };
}
