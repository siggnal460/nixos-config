{ pkgs, ... }:
{
  imports = [
    ../../../shared/podman.nix
  ];

  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama-rocm;
    host = "127.0.0.1";
    loadModels = [
      #"gemma3:latest"
      "devstral:latest"
      "hf.co/DavidAU/OpenAi-GPT-oss-20b-HERETIC-uncensored-NEO-Imatrix-gguf"
    ];
  };

  users.users.aaron.extraGroups = [ "adbusers" ];

  environment.systemPackages = with pkgs; [
    android-tools
    cargo
    gcc
    go
    gopls
    rust-analyzer
    zed-editor-fhs
  ];
}
