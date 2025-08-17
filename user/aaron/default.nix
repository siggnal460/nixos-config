{
  pkgs,
  inputs,
  config,
  ...
}:
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
          "ai"
          "games"
        ];
        initialPassword = "@C4ntG23ss!"; # change later
        openssh.authorizedKeys.keys = [
          # TODO
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPT4DSBvZkQUqrHa6H/58WI/D7CNi+Tf0keXMN5GXq0F aaron@x86-atxtwr-workstation"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6qoMeTk0TOemjL41fTreiTkuql+7or1lQ4dFuPy+Xu aaron@x86-laptop-galago"
        ];
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/aaron 0744 aaron aaron"
  ];

  users.groups = {
    aaron = {
      gid = config.users.users.aaron.uid;
      members = [ "aaron" ];
    };
    media = {
      gid = 982;
    };
    ai = {
      gid = 780;
    };
    games = {
      gid = 770;
    };
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

    stylix = {
      enable = true;
      autoEnable = true;
      targets.gtk.enable = true; # https://github.com/danth/stylix/issues/1093
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };

    accounts.email.accounts.aaron = {
      address = "siggnal@proton.me";
      primary = true;
    };
  };
}
