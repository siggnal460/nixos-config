{
  pkgs,
  inputs,
  config,
  ...
}:
let
  losslessDll =
    if (config.gappyland.jovian) then
      "/home/aaron/.steam/steam/SteamApps/common/Lossless Scaling/Lossless.dll"
    else
      "/home/aaron/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/common/Lossless Scaling/Lossless.dll";
in
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

    home.file."/.config/lsfg-vk/conf.toml" = {
      source = (pkgs.formats.toml { }).generate "lsfg-vk-configuration" {
        version = 1;
        global = {
          dll = losslessDll;
        };
        game = [
          {
            exe = "vkcube";
            multiplier = 4;
          }
          {
            # for use with "LSFG_PROCESS"
            exe = "lsfg2";
            multiplier = 2;
          }
          {
            # for use with "LSFG_PROCESS"
            exe = "lsfg3";
            multiplier = 3;
          }
          #{
          #{
          #  exe = "retroarch";
          #  multiplier = 2;
          #}
        ];
      };
    };

    sops.age.generateKey = true;

    stylix = {
      enable = true;
      autoEnable = true;
      targets.gtk.enable = false; # https://github.com/danth/stylix/issues/1093
    };

    accounts.email.accounts.aaron = {
      address = "siggnal@proton.me";
      primary = true;
    };
  };
}
