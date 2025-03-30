{
  description = "aaron's nixos system configuration flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
      "https://nix-gaming.cachix.org"
      "https://ai.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-24.11";
    stylix-unstable.url = "github:danth/stylix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nixified-ai.url = "github:nixified-ai/flake";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      home-manager,
      home-manager-unstable,
      jovian-nixos,
      nix-index-database,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      stylix,
      stylix-unstable,
      ...
    }:

    let
      overlay-unstable = _final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };

      mkComputerStable =
        _system: configurationNix: extraModules: extraHomeModules:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixpkgs;
          };
          modules = [
            configurationNix
            (
              { ... }:
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            sops-nix.nixosModules.sops
            stylix.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
            ./system
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              #home-manager.useUserPackages = true;
              imports = [ ./user ] ++ extraHomeModules;
            }
          ] ++ extraModules; # system modules
        };

      mkComputerUnstable =
        _system: configurationNix: extraModules: extraHomeModules:
        inputs.nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixpkgs-unstable;
          };
          modules = [
            configurationNix
            (
              { ... }:
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            inputs.jovian-nixos.nixosModules.default
            sops-nix.nixosModules.sops
            stylix-unstable.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
            ./system
            home-manager-unstable.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              #home-manager.useGlobalPkgs = true;
              imports = [ ./user ] ++ extraHomeModules;
            }
          ] ++ extraModules; # system modules
        };

    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations = {
        ## WORKSTATIONS ##
        x86-galago-galago =
          mkComputerUnstable "x86_64-linux" ./host/x86-laptop-galago # machine specific configuration
            [
              #system-wide modules
              ./system/hardware/gpu/intel
              ./system/hardware/thunderbolt
              ./system/de/cosmic
              ./system/baseline/workstation
              ./system/baseline/workstation/gamedev
              ./system/baseline/workstation/vm-host
            ]
            [
              #user-specific modules
              ./user/aaron/workstation
            ];

        x86-laptop-thinkpad =
          mkComputerUnstable "x86_64-linux" ./host/x86-laptop-thinkpad
            [
              ./system/hardware/gpu/amd
              ./system/hardware/laptop
              ./system/baseline/workstation
            ]
            [ ./user/aaron/workstation ];

        x86-atxtwr-workstation =
          mkComputerUnstable "x86_64-linux" ./host/x86-atxtwr-workstation
            [
              ./system/hardware/gpu/amd
              ./system/hardware/gpu/amd/rocm
              ./system/de/cosmic
              ./system/baseline/workstation
              ./system/baseline/workstation/gaming
              ./system/baseline/workstation/gamedev-amd
              ./system/baseline/workstation/development
            ]
            [ ./user/aaron/workstation ];

        ## TABLETS ##
        x86-tablet-starlite =
          mkComputerUnstable "x86_64-linux" ./host/x86-tablet-starlite
            [
              ./system/hardware/tablet
              ./system/baseline/workstation
              ./system/baseline/workstation/art
            ]
            [ ./user/aaron/workstation ];

        ## CONSOLES ##
        x86-minitx-jovian =
          mkComputerUnstable "x86_64-linux" ./host/x86-minitx-jovian
            [
              ./system/de/cosmic
              ./system/hardware/gpu/amd
              ./system/baseline/console
            ]
            [ ./user/aaron/console ];

        x86-stmdck-jovian =
          mkComputerUnstable "x86_64-linux" ./host/x86-stmdck-jovian
            [
              ./system/hardware/gpu/amd
              ./system/hardware/steam-deck
              ./system/baseline/console
            ]
            [ ./user/aaron/console ];

        ## HTPC ##
        x86-merkat-htpc =
          mkComputerStable "x86_64-linux" ./host/x86-merkat-htpc
            [
              ./system/hardware/gpu/intel
              ./system/baseline/htpc
            ]
            [ ./user/kodi ];

        ## SERVERS ##
        x86-merkat-auth =
          mkComputerStable "x86_64-linux" ./host/x86-merkat-auth
            [
              ./system/baseline/server
              ./system/baseline/server/auth
              ./system/baseline/server/beszel-hub
              ./system/baseline/server/beszel-agent
            ]
            [ ];

        x86-merkat-entry =
          mkComputerStable "x86_64-linux" ./host/x86-merkat-entry
            [
              ./system/baseline/server
              ./system/baseline/server/reverse-proxy
              ./system/baseline/server/homepage
              ./system/baseline/server/beszel-agent
              #./system/baseline/server/headscale
            ]
            [ ];

        x86-atxtwr-computeserver =
          mkComputerUnstable "x86_64-linux" ./host/x86-atxtwr-computeserver
            [
              ./system/hardware/gpu/nvidia
              ./system/hardware/gpu/nvidia/cuda
              ./system/baseline/server
              ./system/baseline/server/ai
              ./system/baseline/server/blender
              ./system/baseline/server/nfs
              ./system/baseline/server/beszel-agent
              ./system/baseline/server/gitea
            ]
            [ ];

        x86-rakmnt-mediaserver =
          mkComputerStable "x86_64-linux" ./host/x86-rakmnt-mediaserver
            [
              ./system/hardware/gpu/nvidia
              ./system/hardware/gpu/nvidia/cuda
              ./system/baseline/server
              ./system/baseline/server/openvpn-client
              #./system/baseline/server/streaming
              ./system/baseline/server/media
              ./system/baseline/server/emulatorjs
              ./system/baseline/server/download-client
              ./system/baseline/server/nfs
              ./system/baseline/server/samba
              ./system/baseline/server/netbootxyz
              ./system/baseline/server/nextcloud
              ./system/baseline/server/beszel-agent
            ]
            [ ];
      };
    };
}
