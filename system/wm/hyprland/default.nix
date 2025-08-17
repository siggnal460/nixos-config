{
   programs = {
    hyprland = {
      enable = true;
      xwayland.enable = false;
      withUWSM = true;
    };
  };

  services = {
    displayManager.cosmic-greeter.enable = true;
  };
}
