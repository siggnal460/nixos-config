{ pkgs, inputs, ... }:
{
  users = {
    users = {
      aaron = {
        uid = 1000;
        ignoreShellProgramCheck = true;
        createHome = true;
        isNormalUser = true;
        shell = pkgs.nushell;
        extraGroups = [
          "aaron"
          "wheel"
          "networkmanager"
          "media"
        ];
        initialPassword = "password"; # change later
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7gqadO+NALSkM+6crvnMdCsYycZqhPVIonv8kLrKS/ aaron@x86-atxtwr-workstation"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhR18cn0PfkxNdXB86YunEimpiVst9Ca5QJYHwNeYXX aaron@x86-minitx-jovian"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHWbfQRrluSlaCohXm8/Qvpx1a80N4IEGHF8koRAdDZ aaron@x86-atxtwr-computeserver"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE98YnJuSgl9Swf4P1g6C4hvG5GPSTdHyXf83/GJ4LR7 aaron@nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvz32rDPSRNQlyuSXO3wvz6MlbMdiMUeJvQcgtg+5T5 aaron@x86-merkat-entrymaster"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExo/6fWz0F9ofC/73eff34LALKalVP63bzAyiIZeJFF aaron@x86-merkat-htpc"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWda3Zp3cPUWIPW4vgNxNbXqkzEd/h6onj9BYWvPVBm aaron@nixos"
        ];
      };
    };
    groups = {
      aaron = {
        members = [ "aaron" ];
      };
    };
  };

  users.groups.media = {
    gid = 982;
  };

  systemd = {
    tmpfiles.rules = [ "d /home/aaron/Projects 0700 aaron aaron" ];
  };

  nix.settings.trusted-users = [ "aaron" ];

  home-manager.users.aaron = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
      ./programs/git
      ./programs/nvim
      ./programs/nushell
      ./programs/starship
      ./programs/zellij
    ];

    home = {
      username = "aaron";
      homeDirectory = "/home/aaron";
      stateVersion = "23.11";
    };

    sops.age.generateKey = true;

    accounts.email.accounts.aaron = {
      address = "siggnal@proton.me";
      primary = true;
    };
  };
}
