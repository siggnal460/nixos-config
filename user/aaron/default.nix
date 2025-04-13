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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeYyHUVTW8PW6ipa+meN0DDlB6HXmAbHEnhfxdan+IW aaron@x86-minitx-jovian"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHWbfQRrluSlaCohXm8/Qvpx1a80N4IEGHF8koRAdDZ aaron@x86-atxtwr-computeserver"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILudmn/T9/m1Sb1jzDN/WX5lroyoUhZw3amSEWhFbPWk aaron@x86-merkat-auth"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ3ENb2iqe0ZgY+31q4+alGbWdFW5IEI3pznl8gBfAW aaron@x86-merkat-entry"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExo/6fWz0F9ofC/73eff34LALKalVP63bzAyiIZeJFF aaron@x86-merkat-htpc"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa7ILHCAxlkQI1c5jnwMIaVN2+bQ1GXeukbER5fzBxX aaron@x86-merkat-lrhtpc"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGy+YGfa+dCd7S9Jm6hXWW+TQqgjdPIUlP2+ijZTCqc aaron@x86-rakmnt-mediaserver"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7eGbYxgJi+4wDmKWPxg0lnWDET8Lmns8TfnCyaG/6r aaron@x86-stmdck-jovian"
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
