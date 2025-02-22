{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    settings = {
      "title" = "Gappyland";
      "description" = "Gappy makes me happy";
      "theme" = "dark";
    };
    widgets = [
      {
        jellyfin = {
          "type" = "jellyfin";
          "url" = "https://media.gappyland.org/jellfin";
          "enableBlocks" = "true";
          "enableNowPlaying" = "true";
          "enableUser" = "true";
          "ShowEpisodeNumber" = "true";
          "expandOneStreamToTwoRows" = "false";
        };
      }
    ];
  };
}
