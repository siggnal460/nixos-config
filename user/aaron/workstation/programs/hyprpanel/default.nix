{
  programs.hyprpanel = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./config.json);
  };
}
