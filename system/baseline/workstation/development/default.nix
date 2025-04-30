{ pkgs, ... }:
{
  imports = [
    ../../../shared/podman.nix
  ];

  services.ollama = {
    enable = true;
    loadModels = [
      "gemma3:27b"
      "gemma3:12b"
    ];
  };

  programs.adb.enable = true;
  users.users.aaron.extraGroups = [ "adbusers" ];

  environment.systemPackages = with pkgs; [
    cargo
    gcc
    go
    nil
    nixd
    rust-analyzer
    zed-editor
  ];
}
