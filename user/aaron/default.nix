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
        ];
        initialPassword = "password"; # change later
        openssh.authorizedKeys.keys = [
          ""
        ];
      };
    };
    groups = {
      aaron = {
        members = [ "aaron" ];
      };
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d /home/aaron/Projects 0700 aaron aaron"
    ];
  };

  nix.settings.trusted-users = [ "aaron" ];

  home-manager.users.aaron = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
      ./programs/git
      ./programs/nvim
      ./programs/nushell
      ./programs/starship
      #./programs/zellij
    ];
    home = {
      username = "aaron";
      homeDirectory = "/home/aaron";
      stateVersion = "23.11";
    };

    sops = {
      age.keyFile = "/home/aaron/.config/sops/age/keys.txt";
      defaultSopsFile = ../../../secrets/secrets.yaml;
      age.sshKeyPaths = [ "/home/aaron/.ssh/id_ed25519" ];
      age.generateKey = true;
      defaultSopsFormat = "yaml";
      validateSopsFiles = false;
    };

    accounts.email.accounts.aaron = {
      address = "siggnal@proton.me";
      primary = true;
    };
  };
}