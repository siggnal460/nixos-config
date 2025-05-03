{ pkgs, inputs, ... }:
{
  imports = [
    #./latest-kernel.nix
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

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;

  systemd.services.flatpak-app-installer = {
    wantedBy = [ "multi-user.target" ];
    After = [ "flatpak-install" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak install -y --noninteractive flathub com.valvesoftware.Steam//stable
      flatpak install -y --noninteractive flathub org.freedesktop.Platform.VulkanLayer.MangoHud//24.08
      flatpak install -y --noninteractive flathub dev.goats.xivlauncher
      flatpak override --env=MANGOHUD=1 com.valvesoftware.Steam
      flatpak override --env=MANGOHUD_CONFIG=fps_limit=175 com.valvesoftware.Steam
    '';
  };
}
