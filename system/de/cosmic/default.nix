{
  programs = {
    uwsm = {
      enable = true;
      waylandCompositors.cosmic = {
        prettyName = "COSMIC";
        comment = "System76's COSMIC Desktop Environment";
        binPath = "/run/current-system/sw/bin/cosmic-session";
      };
    };
  };

  services = {
    desktopManager.cosmic.enable = true;
  };
}
