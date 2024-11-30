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

  #programs.gamemode = {
  #  enable = true;
  #  settings = {
  #    general.defaultgov = "performance";
  #  };
  #};

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
      			if ! flatpak list --app | grep -q "com.valvesoftware.Steam"; then
      				flatpak install -y flathub com.valvesoftware.Steam
      			else
      			  echo "Steam flatpak already installed"
      			fi
      			flatpak update -y
    '';
  };

  #system.environmentPackages = with pkgs; [
  #  proton.ge-custom
  #];
}
