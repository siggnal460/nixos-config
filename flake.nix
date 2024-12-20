{
  description = "aaron's nixos system configuration flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nyx.chaotic.cx/"
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
      "https://nix-gaming.cachix.org"
      "https://ai.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
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
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nixified-ai.url = "github:nixified-ai/flake";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      home-manager-unstable,
      sops-nix,
      nixos-hardware,
      jovian-nixos,
      nix-gaming,
      nix-index-database,
      nixified-ai,
      chaotic,
      nixos-cosmic,
      ...
    }:
    let
      mkComputerStable =
        system: configurationNix: extraModules: extraHomeModules:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixpkgs;
          };
          modules = [
            configurationNix
            sops-nix.nixosModules.sops
            nix-index-database.nixosModules.nix-index
            ./system
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              imports = [ ./user ] ++ extraHomeModules;
            }
          ] ++ extraModules; # system modules
        };
      mkComputerUnstable =
        system: configurationNix: extraModules: extraHomeModules:
        inputs.nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixpkgs-unstable;
          };
          modules = [
            configurationNix
            sops-nix.nixosModules.sops
            chaotic.nixosModules.default
            nix-index-database.nixosModules.nix-index
            ./system
            home-manager-unstable.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              imports = [ ./user ] ++ extraHomeModules;
            }
          ] ++ extraModules; # system modules
        };
    in
    {
      nixosConfigurations = {
        ## WORKSTATIONS ##
        x86-laptop-galago =
          mkComputerUnstable "x86_64-linux" ./host/x86-laptop-galago # machine specific configuration
            [
              #system-wide modules
              ./system/hardware/gpu/intel
              ./system/hardware/thunderbolt
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
              ./system/de/plasma.nix
              ./system/baseline/workstation
              ./system/baseline/workstation/ai-amd
              ./system/baseline/workstation/gaming
              ./system/baseline/workstation/gamedev-amd
              ./system/baseline/workstation/development
            ]
            [ ./user/aaron/workstation ];

        ## CONSOLES ##
        x86-minitx-jovian =
          mkComputerUnstable "x86_64-linux" ./host/x86-minitx-jovian
            [
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
            [ ./user/aaron/htpc ];

        ## SERVERS ##
        x86-merkat-entry =
          mkComputerStable "x86_64-linux" ./host/x86-merkat-entry
            [
              ./system/hardware/gpu/intel
              ./system/baseline/server
              ./system/baseline/server/caddy
              ./system/baseline/server/headscale
            ]
            [ ];

        x86-merkat-webserver =
          mkComputerUnstable "x86_64-linux" ./host/x86-merkat-webserver
            [
              ./system/hardware/gpu/intel
              ./system/baseline/server
              ./system/baseline/server/nextcloud
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
            ]
            [ ];

        x86-rakmnt-mediaserver =
          mkComputerStable "x86_64-linux" ./host/x86-rakmnt-mediaserver
            [
              ./system/hardware/gpu/nvidia
              ./system/hardware/gpu/nvidia/cuda
              ./system/baseline/server
              ./system/baseline/server/streaming
              ./system/baseline/server/media
              ./system/baseline/server/torrent
              ./system/baseline/server/nfs
            ]
            [ ];
      };
    };
}
