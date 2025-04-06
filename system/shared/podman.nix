{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "Tue *-*-* 00:45:00";
        flags = [ "--all" ];
      };
    };
  };

  virtualisation.oci-containers.backend = "podman";
}
