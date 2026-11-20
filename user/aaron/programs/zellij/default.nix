{
  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
      show_release_notes = false;
      nested_session_handling = "never";
      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };
    };
  };
}
