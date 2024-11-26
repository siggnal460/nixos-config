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

  programs.steam = {
    enable = true;
    platformOptimizations.enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  #system.environmentPackages = with pkgs; [
  #  proton.ge-custom
  #];
}
