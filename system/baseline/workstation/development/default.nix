{ pkgs, ... }:
{
  imports = [ ../../../shared/podman.nix ];

  environment.systemPackages = with pkgs; [
    cargo
    gcc
    nil
    nixd
    rust-analyzer
    zed-editor
  ];
}
