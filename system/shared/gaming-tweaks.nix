{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./latest-kernel.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  services.pipewire.lowLatency = {
    enable = true;
    quantum = 64;
    rate = 48000;
  };

  # This always fucking breaks...
  #programs.steam = {
  #  enable = true;
  #	package = pkgsStable.steam;
  #  platformOptimizations.enable = true;
  #  extest.enable = true;
  #  extraCompatPackages = with pkgs; [
  #    proton-ge-bin
  #  ];
  #};

  services.flatpak.enable = true;

  systemd.services.flatpak-app-installer = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak uninstall --unused -y --noninteractive
      flatpak install -y --noninteractive flathub com.valvesoftware.Steam//stable
      flatpak install -y --noninteractive flathub org.freedesktop.Platform.VulkanLayer.MangoHud//24.08
      flatpak install -y --noninteractive flathub com.discordapp.Discord//stable
      flatpak override --env=MANGOHUD=1 com.valvesoftware.Steam
      flatpak override --env=MANGOHUD_CONFIG=fps_limit=175 com.valvesoftware.Steam
      flatpak update -y
    '';
  };

}
