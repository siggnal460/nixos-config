{
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.enable = false;
    relay.enable = false;
  };
}
