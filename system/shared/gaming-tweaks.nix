{ pkgs, inputs, lib, ... }:
let
  mountOptions = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "_netdev"
  ];
in
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

	users.groups = {
		games = {
			gid = 770;
		};
	};

  systemd.tmpfiles.rules = [
    "d /nfs/games 0775 root games"
	];

  fileSystems = {
    "/nfs/games" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/games";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
	};

  services = {
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;

  systemd.services.flatpak-gaming-tweaks = {
    wantedBy = [ "multi-user.target" ];
    after = [ "flatpak-install.service" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak install -y --noninteractive flathub com.valvesoftware.Steam//stable
      flatpak install -y --noninteractive flathub org.freedesktop.Platform.VulkanLayer.MangoHud//24.08
      flatpak install -y --noninteractive flathub dev.goats.xivlauncher
      flatpak override --env=MANGOHUD=1 com.valvesoftware.Steam
			flatpak override --filesystem=/nfs/games com.valvesoftware.Steam 
    '';
  };
}
