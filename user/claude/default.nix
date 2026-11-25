{ config, pkgs, ... }:
{
  users.users.claude = {
    uid = 1002;
    ignoreShellProgramCheck = true;
    createHome = true;
    isNormalUser = true;
    shell = pkgs.bash;
    initialPassword = "claude";
    extraGroups = [
      "nix-users"
      "agents"
      "development"
    ];
  };

  users.groups.claude = {
    gid = config.users.users.claude.uid;
    members = [ "claude" ];
  };

  home-manager.users.claude = {
    home = {
      username = "claude";
      homeDirectory = "/home/claude";
      stateVersion = "23.11";
      packages = [
        pkgs.bubblewrap
        pkgs.socat
      ];
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "siggnal460";
        user.email = "siggnal@proton.me";
        init.defaultBranch = "master";
        # Nix's libgit2-based flake fetcher doesn't honor the trailing "/*"
        # glob that git-core's own safe.directory supports
        safe.directory = [
          "/etc/nixos"
          "/srv/aaron-projects/tofu-aws"
        ];
      };
      includes = [
        {
          condition = "gitdir:/srv/aaron-projects/";
          path = pkgs.writeText "aaron-projects-gitconfig" ''
            [core]
              sharedRepository = group
          '';
        }
      ];
    };

    programs.bash.enable = true;

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.claude-code = {
      enable = true;
      settings = {
        showThinkingSummaries = true;
        sandbox = {
          enabled = true;
          failIfUnavailable = true;
          network = {
            allowAllUnixSockets = true;
          };
        };
        permissions = {
          allow = [
            "Read(/home/claude/*)"
            "Edit(/home/claude/*)"
            "Read(/srv/aaron-projects/*)"
            "Edit(/srv/aaron-projects/*)"
          ];
          blockReadsOutsideWorkingDirectories = true;
          deny = [
            # Personal files
            "Read(/home/aaron/**)"
            "Read(/run/media/**)"

            # System files
            "Read(/etc/**)"
            "Read(/mnt/**)"
            "Read(/nfs/**)"
            "Read(/tmp/**)"

            # Claudes configs
            "Edit(~/.claude/settings.json)"
            "Edit(.claude/settings.json)"

            # Remote access to other hosts must go through the user, not Claude
            "Bash(ssh *)"

            # Secrets managed by NixOS / sops-nix / agenix
            "Read(/run/secrets/**)"
            "Read(/run/agenix/**)"
            "Read(/run/keys/**)"
            "Read(/var/lib/sops-nix/**)"
            "Read(/var/lib/agenix/**)"
            "Read(/etc/ssh/**)"
            "Read(/etc/wireguard/**)"
            "Read(/etc/NetworkManager/system-connections/**)"
            "Read(/etc/shadow)"
            "Read(/etc/gshadow)"
            "Read(**/*secret*)"
            "Read(**/*secrets*)"
            "Read(**/*.age)"
            "Read(**/sops/**)"

            # Nix store derivations that may embed secrets
            "Read(/nix/store/*secret*)"
            "Read(/nix/store/*password*)"
            "Read(/nix/store/*token*)"
            "Read(/nix/store/*key*)"
            "Read(/nix/store/*.pem)"
            "Read(/nix/store/*.age)"

            # Project-level secrets & env files
            "Read(**/.env)"
            "Read(**/.env.*)"
            "Read(**/.dev.vars*)"
            "Read(**/*.pem)"
            "Read(**/*.key)"
            "Read(**/*.p12)"
            "Read(**/*.pfx)"
            "Read(**/credentials/**)"
            "Read(**/credentials.json)"
            "Read(**/*token*)"
            "Read(**/*password*)"

            "Read(**/.terraform/**)"
          ];
        };
        statusLine = {
          type = "command";
          command = "${pkgs.python3}/bin/python3 ${./statusline.py}";
        };
      };
      context = ''
        # Development
        The user prefers to use dev shells using rootless podman, direnv and flakes for development wherever possible - do not assume needed binaries are necessarily in your user PATH.

        # Scratch space
        If a temporary directory is needed for scratch space, just use your own home directory which you should have full access to.

        # Data Access
        Under no circumstance read secrets in plaintext. There should never be manual secrets handling. Leave all secrets creation to the user.

        # Permissions
        You are running under the claude user, which has limited permissions. I am the aaron user.

        # Output & Narration Preferences
        - Before running any tool or editing a file, briefly explain what you are doing and why.
        - State key assumptions and explain the reasoning behind each step.
      '';
    };
  };
}
