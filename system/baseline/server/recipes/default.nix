{
  networking.firewall.allowedTCPPorts = [ 5413 ];

  services.tandoor-recipes = {
    enable = true;
    port = 5413;
    address = "192.168.1.13";
    extraConfig = {
      ENABLE_SIGNUP = 0;
      REMOTE_USER_AUTH = 0;
    };
  };
}
