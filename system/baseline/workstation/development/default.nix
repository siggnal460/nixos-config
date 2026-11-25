{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../../shared/podman.nix
  ];

  programs.direnv.enable = true;

  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    loadModels = [
      "devstral:latest"
    ];
  };

  users.groups.adbusers.members = config.users.primaryUsers;

  environment.systemPackages = with pkgs; [
    android-tools
    cargo
    gcc
    go
    gopls
    nixd
    nodejs
    rust-analyzer
    vscode
  ];
}
