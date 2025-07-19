# Configs that are shared in all builds
{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./extras/current-system-packages.nix
    ./extras/options.nix
  ];

  stylix.targets.plymouth.enable = false;

  zramSwap.enable = true;

  boot = {
    tmp.useTmpfs = lib.mkDefault true;
    tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
    initrd.systemd.enable = true;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"
      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "vivid"
      "gfs2"
      "ksmbd"
      "nfsv3"
      "cifs"
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "squashfs"
      "udf"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
    ];
    kernel.sysctl = {
      "kernel.sysrq" = 0;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };
    kernelModules = [ "tcp_bbr" ];
  };

  hardware.sane.openFirewall = false;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_DK.UTF-8"; # for yuro time
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    stevenblack.enable = true;
    firewall.allowedTCPPorts = [ ];
    firewall.allowedUDPPorts = [ ];
    nameservers = [
      "8.8.8.8"
      "8.8.8.4"
    ];
    # these are temporary
    extraHosts = ''
      192.168.1.3   x86-merkat-auth.gappyland.org x86-merkat-auth
      192.168.1.13  x86-rakmnt-mediaserver
      192.168.1.5   x86-merkat-entry
      192.168.1.6  x86-atxtwr-workstation
      192.168.1.11  x86-merkat-bedhtpc
      192.168.1.42  x86-atxtwr-computeserver
      192.168.1.21  arm-raspi4-downloadclient
      10.0.0.18  x86-stmdck-jovian
      10.0.0.20  x86-minitx-jovian
      10.0.0.23  x86-merkat-lrhtpc
    '';
  };

  programs = {
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 5";
        dates = "Mon *-*-* 00:45:00";
      };
    };
    nix-index-database.comma.enable = true;
    command-not-found.enable = false;
  };

  security = {
    acme.acceptTerms = true;
    protectKernelImage = true;
    apparmor.enable = true;
    apparmor.killUnconfinedConfinables = true;
    #restrict what sudo can do to basic admin functions
    sudo = {
      enable = true;
      execWheelOnly = true;
      extraRules = [
        {
          commands =
            builtins.map
              (command: {
                command = "/run/current-system/sw/bin/${command}";
                options = [ "NOPASSWD" ];
              })
              [
                "poweroff"
                "reboot"
                "nixos-rebuild"
                "nix-env"
                "systemctl"
              ];
          groups = [ "wheel" ];
        }
      ];
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      #only allow root and wheel users to configure nix
      allowed-users = [
        "@wheel"
        "root"
      ];
    };
    optimise = {
      automatic = true;
      dates = [ "00:30" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh.knownHosts = {
    "x86-merkat-entry".publicKey =
	    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ3ENb2iqe0ZgY+31q4+alGbWdFW5IEI3pznl8gBfAW aaron@x86-merkat-entry";
    "x86-rakmnt-mediaserver".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGy+YGfa+dCd7S9Jm6hXWW+TQqgjdPIUlP2+ijZTCqc aaron@x86-rakmnt-mediaserver";
    "x86-minitx-jovian".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeYyHUVTW8PW6ipa+meN0DDlB6HXmAbHEnhfxdan+IW aaron@x86-minitx-jovian";
    "x86-stmdck-jovian".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7eGbYxgJi+4wDmKWPxg0lnWDET8Lmns8TfnCyaG/6r aaron@x86-stmdck-jovian";
    "x86-merkat-htpc".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExo/6fWz0F9ofC/73eff34LALKalVP63bzAyiIZeJFF aaron@x86-merkat-htpc";
  };

  system.stateVersion = "23.11";

  systemd = {
    tmpfiles.rules = [
      "Z /etc/nixos 0770 root wheel"
    ];
  };

  systemd.timers."pull-updates" = {
    description = "nightly timer between 0400-0430 for pulling of latest changes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
		  Persistent = true;
      OnCalendar = "*-*-* 04:00:00";
      RandomizedDelaySec = "30min";
      Unit = "pull-updates.service";
    };
  };

  systemd.services.pull-updates = {
    description = "pulling of latest changes from the upstream git repo";
    restartIfChanged = false;
    onSuccess = [ "rebuild.service" ];
    path = [
      pkgs.git
      pkgs.openssh
    ];
    script = ''
        echo "Checking for master branch..."
      	test "$(git branch --show-current)" = "master"
      	echo "Pulling latest changes..."
      	git pull --ff-only origin master
    '';
    serviceConfig = {
      WorkingDirectory = "/etc/nixos";
      User = "aaron";
      Type = "oneshot";
    };
  };

  systemd.services.rebuild = {
    description = "rebuild and activation of newly pulled system config, reboots or powers off as necessary";
    restartIfChanged = false;
    path = [
      pkgs.nixos-rebuild
      pkgs.systemd
    ];
    script = ''
      echo "Beginning rebuild service."
      current_hour=$(date +%H)

      echo "Rebuild Information - Hostname: $HOSTNAME ; NIGHTLY_REFRESH: $NIGHTLY_REFRESH ; Current Hour: $current_hour"

      echo "Running \"nixos-rebuild boot\"..."
      nixos-rebuild boot -j 3 --accept-flake-config
      booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
      built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

      if [ "$NIGHTLY_REFRESH" = "always-poweroff" ]; then
        echo "Running \"nixos-rebuild switch\"..."
        nixos-rebuild switch --accept-flake-config
        if [ "$current_hour" -ge 3 ] && [ "$current_hour" -lt 5 ]; then
      	  echo "Within poweroff window. Goodbye!"
      	  poweroff
				else
      	  echo "Not within power cycle window of 0200-0500, skipping poweroff."
				fi
      elif [ "''${booted}" = "''${built}" ]; then
        echo "Reboot not necessary."
        echo "Running \"nixos-rebuild switch\"..."
      	nixos-rebuild switch --accept-flake-config
      elif [ "$NIGHTLY_REFRESH" = "reboot-if-needed" ] && [ "$current_hour" -ge 3 ] && [ "$current_hour" -lt  5 ]; then
        echo "Reboot necessary and within reboot window. Rebooting now."
      	reboot now
      elif [ "$NIGHTLY_REFRESH" = "reboot-if-needed" ]; then
      	echo "Refresh is necessary, but it was not within the power cycle window of 0200 and 0500 so it was skipped."
      elif [ "$NIGHTLY_REFRESH" != "reboot-if-needed" ]; then
      	echo 'Environmental variable NIGHTLY_REFRESH was not set to an appropriate value ("always-poweroff" or "reboot-if-needed"). Action will not be taken.'
      else
      	echo "An unknown error occured and no action was taken."
      fi
    '';
    serviceConfig = {
      WorkingDirectory = "/etc/nixos";
      User = "root";
      Type = "oneshot";
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [
      pkgs.stdenv.cc.cc
      pkgs.libgcc.lib
    ];
  };

  systemd = {
    coredump.enable = false;
  };

  users.defaultUserShell = pkgs.nushell;

  sops = {
    defaultSopsFormat = lib.mkDefault "yaml";
    age = {
      keyFile = "/var/lib/sops-nix/keys.txt";
      generateKey = true;
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    image = ../images/wallpapers/tux.png;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    fonts = {
      serif = {
        package = pkgs.unstable.nerd-fonts.fira-code;
        name = "Fira Code Serif";
      };

      sansSerif = {
        package = pkgs.unstable.nerd-fonts.fira-code;
        name = "Fira Code Sans";
      };

      monospace = {
        package = pkgs.unstable.nerd-fonts.fira-code;
        name = "Fira Code Mono";
      };

      emoji = {
        package = pkgs.unstable.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
    shells = with pkgs; [ nushell ]; # adds nushell to /etc/shells
    systemPackages = with pkgs; [
      ansible
      deadnix
      freshfetch
      git
      nixfmt-rfc-style
      python313
      ripgrep
      stylua
      treefmt
      (writeScriptBin "nix-switch" (builtins.readFile ../bin/nix-switch.nu))
      wl-clipboard
    ];
  };
}
