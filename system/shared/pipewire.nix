{ pkgs, ... }:

let
  pipewire-start = pkgs.writeTextFile {
    name = "pipewire-start";
    destination = "/bin/pipewire-start";
    executable = true;

    text = ''
      systemctl --user stop pipewire pipewire-media-session
      systemctl --user start pipewire pipewire-media-session
    '';
  };
in
{
  security.rtkit.enable = true;
  services = {
    #pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
  environment.systemPackages = [ pipewire-start ];
}
