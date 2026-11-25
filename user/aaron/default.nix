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
          "development"
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
    "d /home/aaron 0740 aaron aaron"
    "d /home/aaron/Games 0744 aaron aaron"
    "d /srv/aaron-projects 2774 aaron development"
    "Z /srv/aaron-projects - - development -"
    "A /srv/aaron-projects - - - - group:development:rwX,default:group:development:rwX"
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
      # Run claude-code as the restricted `claude` user instead of as aaron.
      # -H sets HOME=/home/claude (without resetting other inherited env vars)
      # so claude-code reads its own config/credentials, while sudo without -i
      # keeps aaron's cwd. The per-user profile path is a stable symlink kept
      # current by home-manager activation (useUserPackages/useGlobalPkgs).
      packages = [
        (pkgs.writeShellScriptBin "claude" ''
          exec sudo -H -u claude /etc/profiles/per-user/claude/bin/claude "$@"
        '')
      ];
    };

    sops.age.generateKey = true;
    sops.age.keyFile = "/home/aaron/.config/sops/age/keys.txt";

    stylix = {
      enable = true;
      autoEnable = true;
      targets.gtk.flatpakSupport.enable = false; # https://github.com/danth/stylix/issues/1093
      targets.qt.platform = "qtct"; # stylix doesn't support theming the KDE platform directly
    };

    # Force-overwrite gtk.css symlinks left behind by COSMIC's own theming so Stylix can manage them
    xdg.configFile = {
      "gtk-3.0/gtk.css".force = true;
      "gtk-4.0/gtk.css".force = true;
    };

    services = {
      gammastep = {
        dawnTime = "5:00-6:45";
        duskTime = "18:45-21:45";
        settings = {
          general = {
            adjustment-method = "wayland";
          };
        };
      };
    };

    accounts.email.accounts.aaron = {
      address = "siggnal@proton.me";
      primary = true;
    };
  };
}
