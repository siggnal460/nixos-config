{ pkgs, ... }:
{
  imports = [
    ../../../shared/podman.nix
  ];

  #services.ollama = {
  #  enable = true;
  #  host = "0.0.0.0";
  #  environmentVariables = {
  #    OLLAMA_HOST = "0.0.0.0:11434";
  #  };
  #  loadModels = [
  #    "devstral:latest"
  #  ];
  #};

  users.users.aaron.extraGroups = [ "adbusers" ];

  environment.systemPackages = with pkgs; [
    android-tools
    cargo
    gcc
    go
    gopls
    rust-analyzer
    #zed-editor-fhs
  ];
}
