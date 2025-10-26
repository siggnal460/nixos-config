{
  services.wyoming = {
    faster-whisper.servers.ha = {
      enable = true;
      uri = "tcp://0.0.0.0:10300";
      language = "en";
      piper.servers.ha = {
        enable = true;
        uri = "tcp://0.0.0.0:10200";
        voice = "en-us-ryan-medium";
      };
    };
  };
}
