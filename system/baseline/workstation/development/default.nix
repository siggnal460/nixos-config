{ pkgs, ... }:
{
  imports = [
    ../../../shared/podman.nix
  ];

  services.ollama = {
    enable = true;
    loadModels = [
      "devstral:latest"
    ];
  };

  programs.adb.enable = true;
  users.users.aaron.extraGroups = [ "adbusers" ];

  environment.systemPackages = with pkgs; [
    cargo
    gcc
    go
    gopls
    nil
    nixd
    rust-analyzer
    zed-editor-fhs
  ];
}
