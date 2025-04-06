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
        openssh.authorizedKeys.keyFiles = [ "/home/aaron/.ssh/id_ed25519.pub" ];
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
