# Overview

This is my NixOS configuration repo for my workstations and homelab

- x86-atxtwr-workstation: My main gaming PC, configuration optimized for personal computing
- x86-merkat-auth: headless auth server, runs Authelia and LLDAP
- x86-merkat-entry: headless entrypoint into homelab services, contains reverse proxy and homepage
- x86-rakmnt-mediaserver: headless fileserver hosting most services
- x86-minitx-jovian: A SteamOS-like gaming console attached to a TV
- x86-stmdck-jovian: Handheld gaming PC

# Philosophy

Things should generally be done in nix whenever possible, employing other programming languages as a last resort. The goal is to be pure and declarative. My entire system configuration should be contained within this repository.

# Testing

Always test with dry-runs. Ensure both stable and unstable are tested and fix any build errors or warnings you see. When testing stable, just test the workstation flake. It will be largely cached and be must faster to check.

# Hosts

Each host has a flake. I run most of my hosts on stable, other than the Jovian hosts which require unstable. You will not be able to access these hosts, always assume you are running form x86-atxtwr-workstation.

## Structure

- **bin**: Contains any custom scripts I've made. These are added to the Nix store and system PATH.
  - nix-switch: Convenience nushell script for updating the system, formatting each file with nixfmt, and keeping it in sync with a remote repo.
- **images**: Various images such as wallpapers, icons, etc.
- **user**: Per-user configs. Mostly home-manager modules.
    - user folders are broken out into several folders depending on the type of machine: console, workstations, htpc, etc. There is also host-specific configurations.
- **hosts**: Host-specific modules. For things such as setting hostnames and static IPs. Also contains each system's hardware-configuration.nix.
- **secrets**: Per-host sops-nix yaml secret files.
- **system**: System-wide modules.
  - baseline: Outlines of basic computer archetypes. In each baseline are also submodules pertaining to that archetype for more specialized functionality. Only one baseline should be used per machine, and submodules are only meant to work within that baseline.
    - console: Gaming console using Jovian and gamescope as the default interface.
    - htpc: Home Theater PC using Kodi as the default interface.
    - server: Headless, remotely-accessed machines running services.
    - workstation: Machines that are directly accessed via mouse and keyboard.
  - extras: Additional nix tools I've made.
  - hardware: Modules for certain hardware setups, e.g. graphics card drivers, SteamDeck firmware, etc.
  - shared: Modules that have functionality which is shared among other modules. These are not meant to be imported into the flake directly.

# Timer Schedule

| Process                             | Time      |
| ----------------------------------- | --------- |
| Podman auto-upgrade (default)       | 1045      |
| Podman auto-upgrade (computeserver) | 0000      |
| restic backup (Jellyfin)            | 0010      |
| nix store optimization              | 0030      |
| nh garbage collection               | 0045 Mon  |
| Podman garbage collection           | 0045 Tue  |
| ClamAV scanning                     | 0100      |
| Podman auto-upgrade (mediaserver)   | 0115      |
| Podman auto-upgrade (downloadclient)| 0230      |
| update-flake-lock GH Action         | 0330      |
| NixOS auto-upgrade window           | 0400-0430 |
| poweroff/reboot window              | 0400-0500 |

I purposefully spread out podman auto-upgrades between hosts because otherwise I will run into hourly rate limits.
