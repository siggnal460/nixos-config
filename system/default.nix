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
  ];

  boot = {
    tmp.useTmpfs = lib.mkDefault true;
    tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
    initrd.systemd.enable = true;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
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
      "nfsv4"
      "nfsv3"
      "cifs"
      "nfs"
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
    firewall.enable = true;
    networkmanager.enable = true;
    stevenblack.enable = true;
    firewall.allowedTCPPorts = [ ];
    firewall.allowedUDPPorts = [ ];
    defaultGateway = "10.0.0.1";
    nameservers = [ "8.8.8.8" ];
    #    extraHosts = ''
    #      127.0.0.1 localhost
    #      10.0.0.11 x86-atxtwr-computeserver
    #      10.1.0.1  x86-thnkpd-netman
    #      10.2.0.1  x86-galago-servman
    #      10.3.0.1  arm-rasbpi-rproxy
    #      10.4.0.1  x86-racmnt-mediaserv
    #      10.5.0.1  arm-rasbpi-secretserv
    #      10.5.0.2  arm-rasbpi-backupser
    #      10.5.0.3  arm-rasbpi-torrentserv
    #      10.5.0.4  x86-merkat-testserv
    #      10.6.0.1  x86-atxtwr-gamingpc
    #      10.6.0.2  x86-minitx-jovian
    #      10.6.0.3  x86-stmdck-jovian
    #      10.6.0.4  x86-cphone-graphene
    #      10.6.0.5  x86-merkat-htpc
    #    '';
  };

  programs = {
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 5";
        dates = "weekly";
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
    auditd.enable = true;
    audit.enable = true;
    audit.rules = [
      "-a exit,always -F arch=b64 -S execve"
    ];
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

  services = {
    clamav = {
      daemon.enable = true;
      updater.enable = true;
      updater.interval = "daily";
      updater.frequency = 1;
    };
  };

  fonts = {
    packages = with pkgs; [
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif # no tofu
    ];
    fontconfig.defaultFonts = {
      serif = [
        "FiraCode"
        "noto-fonts"
      ];
      emoji = [ "FiraCode" ];
      sansSerif = [
        "FiraCode"
        "noto-fonts"
      ];
      monospace = [
        "FiraCode"
        "noto-fonts"
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
  };

  security.sudo.wheelNeedsPassword = false;

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      flake = "$/etc/nixos";
      allowReboot = true;
      persistent = true;
      randomizedDelaySec = "210min";
      dates = "00:30";
      rebootWindow = {
        lower = "00:30";
        upper = "04:00";
      };
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [
      pkgs.stdenv.cc.cc
      pkgs.libgcc.lib
    ];
  };

  systemd.coredump.enable = false;

  users.defaultUserShell = pkgs.nushell;

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
      freshfetch
      git
      nixfmt-rfc-style
      ripgrep
      (writeScriptBin "nix-switch" (builtins.readFile ../bin/nix-switch.nu))
      wl-clipboard
    ];
  };
}