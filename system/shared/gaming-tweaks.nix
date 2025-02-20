{ pkgs, inputs, ... }:
{
  imports = [
    ./latest-kernel.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  services = {
    #scx = {
    #  enable = true;
    #  scheduler = "scx_lavd";
    #};
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  services.flatpak.enable = true;

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;

  systemd.services.flatpak-app-installer = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak uninstall --unused -y --noninteractive
      flatpak install -y --noninteractive flathub com.valvesoftware.Steam//stable
      flatpak install -y --noninteractive flathub org.freedesktop.Platform.VulkanLayer.MangoHud//24.08
      flatpak install -y --noninteractive flathub io.github.equicord.equibop
      flatpak install -y --noninteractive flathub dev.goats.xivlauncher
      flatpak override --env=MANGOHUD=1 com.valvesoftware.Steam
      flatpak override --env=MANGOHUD_CONFIG=fps_limit=175 com.valvesoftware.Steam
      flatpak update -y
    '';
  };
}
